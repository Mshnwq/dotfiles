# programs/yazi/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.yazi;
  # https://github.com/sxyazi/yazi/issues/694
  # https://forum.obsidian.md/t/enable-use-access-to-hidden-files-and-folders-starting-with-a-dot-dotfiles-dotfolders-within-obsidian/26908
  patched-yazi =
    let
      yazi-unwrapped-patched =
        inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi-unwrapped.overrideAttrs
          (old: {
            postPatch = (old.postPatch or "") + ''
              awk '
                /starts_with\("\."\)/ {
                  print "\t\t\tif _name.as_strand().starts_with(\".\") || (_meta.is_dir() && (_name.as_strand().starts_with(\"_templates\") || _name.as_strand().starts_with(\"_attachments\"))) {"
                  next
                }
                { print }
              ' yazi-fs/src/cha/kind.rs > kind.rs.tmp && mv kind.rs.tmp yazi-fs/src/cha/kind.rs
              echo "=== PATCHED kind.rs ===" >&2
              cat yazi-fs/src/cha/kind.rs >&2
            '';
          });
    in
    inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi.override {
      yazi-unwrapped = yazi-unwrapped-patched;
    };

  # Import plugin definitions
  pluginDefs = import ./plugins.nix { inherit pkgs inputs; };
  # TODO: add ClipBoard Plugin
  availablePlugins = pluginDefs.plugins;

  # Filter enabled plugins
  enabledPlugins = lib.filterAttrs (
    name: plugin: cfg.pluginSettings.${name}.enable
  ) availablePlugins;

  # Convert to the format yazi.plugins expects
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
  # mergedSettings = lib.foldl' lib.recursiveUpdate baseSettings pluginsSettings;
  # TODO: so ugly
  mergePluginSettings =
    a: b:
    let
      mergePlugin = key: (a.plugin.${key} or [ ]) ++ (b.plugin.${key} or [ ]);
      mergeOpener = key: (a.opener.${key} or [ ]) ++ (b.opener.${key} or [ ]);
      openerKeys = [ "play" ];
      pluginKeys = [
        "prepend_preloaders"
        "prepend_previewers"
      ];
    in
    lib.recursiveUpdate a (
      (lib.optionalAttrs (b ? plugin) {
        plugin = lib.genAttrs pluginKeys mergePlugin;
      })
      // (lib.optionalAttrs (b ? opener) {
        opener = lib.genAttrs openerKeys mergeOpener;
      })
    );
  mergedSettings = lib.foldl' mergePluginSettings baseSettings pluginsSettings;

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
  options.yazi.pluginSettings = lib.mkOption {
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

  options.yazi.sops.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    yazi.pluginSettings = lib.mapAttrs (name: plugin: {
      enable = lib.mkDefault plugin.defaultEnable;
    }) availablePlugins;

    home.packages = with pkgs; [
      gnome-epub-thumbnailer
      trash-cli
      mediainfo
      exiftool
    ];

    programs.yazi = {
      enable = true;
      # package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      package = patched-yazi;
      enableZshIntegration = false;
      enableBashIntegration = false;
      plugins = pluginsConfig;
      initLua = mergedInitLua;
      settings = mergedSettings;
    };

    sops.secrets.yazi-goto.mode = "0400";
    home.activation.yaziKeymap = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      baseToml=${(pkgs.formats.toml { }).generate "keymap.toml" mergedKeymap}
      target="${config.home.homeDirectory}/.config/yazi/keymap.toml"
      cat "$baseToml" > "$target"
      ${lib.optionalString (config.yazi.sops.enable) ''
        secret="${config.sops.secrets."yazi-goto".path}"
        if [ -f "$secret" ]; then
          cat "$secret" >> "$target"
        else
          echo "Yazi secret not found: $secret"
        fi
      ''}
    '';
  };
}
