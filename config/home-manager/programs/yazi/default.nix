# programs/yazi/default.nix
{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.yazi;

  # Import plugin definitions
  pluginDefs = import ./plugins.nix { inherit pkgs; };
  availablePlugins = pluginDefs.plugins;

  # Filter enabled plugins
  enabledPlugins = lib.filterAttrs (
    name: plugin: cfg.pluginSettings.${name}.enable
  ) availablePlugins;

  # Convert to the format programs.yazi.plugins expects
  pluginsConfig = lib.mapAttrs (name: plugin: plugin.source) enabledPlugins;

  # Import base keymap and merge with enabled plugin keymaps
  baseKeymap = import ./keymap.nix { };
  pluginsKeymap = lib.flatten (
    lib.mapAttrsToList (name: plugin: plugin.keymap or [ ]) enabledPlugins
  );
  mergedKeymap = baseKeymap // {
    mgr = (baseKeymap.mgr or { }) // {
      prepend_keymap = (baseKeymap.mgr.prepend_keymap or [ ]) ++ pluginsKeymap;
    };
  };

  # Import base settings and merge with enabled plugin settings
  baseSettings = import ./settings.nix { };
  pluginsSettings = lib.mapAttrsToList (
    name: plugin: plugin.settings or { }
  ) enabledPlugins;
  mergedSettings = lib.foldl' lib.recursiveUpdate baseSettings pluginsSettings;

  # Import base initlua and merge with enabled plugin initlua
  baseInitLua = builtins.readFile ./init.lua;
  pluginsInitLua = lib.mapAttrsToList (
    name: plugin: plugin.initLua or ""
  ) enabledPlugins;
  mergedInitLua = ''
    ${baseInitLua}
    ${lib.concatStringsSep "\n" pluginsInitLua}
  '';
in
{
  options.programs.yazi.pluginSettings = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to enable this Yazi plugin";
          };
        };
      }
    );
    default = { };
    description = "Settings for individual Yazi plugins";
  };

  config = {
    programs.yazi.pluginSettings = lib.mapAttrs (name: plugin: {
      enable = lib.mkDefault plugin.defaultEnable;
    }) availablePlugins;

    home.packages = with pkgs; [
      yazi
      trash-cli
      mediainfo
      exiftool
    ];

    programs.yazi = {
      enable = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
      plugins = pluginsConfig;
      initLua = mergedInitLua;
      settings = mergedSettings;
      # Only set keymap directly when sops is disabled
      # When sops is enabled, the activation script handles it
      keymap = lib.mkIf (!inputs.useSops) mergedKeymap;
    };

    # Only inject secret paths when sops is enabled
    home.activation.yaziKeymap = lib.mkIf inputs.useSops (
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        baseToml=${(pkgs.formats.toml { }).generate "keymap.toml" mergedKeymap}
        target="${config.home.homeDirectory}/.config/yazi/keymap.toml"
        cat "$baseToml" > "$target"
        secret="${config.sops.secrets."yazi-goto".path}"
        if [ -f "$secret" ]; then
          cat "$secret" >> "$target"
        else
          echo "Yazi secret not found: $secret"
        fi
      ''
    );
  };
}
