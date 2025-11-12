# programs/tmux/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tmux;
  pluginDefs = import ./plugins.nix { inherit pkgs; };
  availablePlugins = pluginDefs.plugins;

  # Build the enabled plugins list based on user settings
  enabledPlugins = lib.filter (p: p != null) (
    lib.mapAttrsToList (
      name: plugin:
      let
        isEnabled = cfg.pluginSettings.${name}.enable or plugin.defaultEnable;
      in
      if isEnabled then
        {
          inherit (plugin) plugin extraConfig;
        }
      else
        null
    ) availablePlugins
  );
in
{
  options.programs.tmux.pluginSettings = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to enable this tmux plugin";
          };
        };
      }
    );
    default = { };
    description = "Settings for individual tmux plugins";
  };

  config = {
    # Set default enable values for all available plugins
    programs.tmux.pluginSettings = lib.mapAttrs (name: plugin: {
      enable = lib.mkDefault plugin.defaultEnable;
    }) availablePlugins;

    home.sessionVariables = {
      TMUXP_CONFIGDIR = "${config.xdg.configHome}/tmux/tmuxp";
    };

    programs.tmux = {
      enable = true;
      shell = "/usr/bin/zsh";
      sensibleOnTop = true;
      terminal = "tmux-256color";
      historyLimit = 1000;
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      shortcut = "Space";
      tmuxp.enable = true;
      extraConfig = import ./config.nix { };
      plugins = enabledPlugins;
    };
  };
}
