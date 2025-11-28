# programs/tmux/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.tmux;
  pluginDefs = import ./plugins.nix { inherit pkgs; };
  availablePlugins = pluginDefs.plugins;
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
  options.tmux.pluginSettings = lib.mkOption {
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

  options.tmux.tmuxp.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable tmuxp";
  };

  options.tmux.systemShell.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  options.tmux.shortcut = lib.mkOption {
    type = lib.types.nonEmptyStr;
    default = "Space";
  };

  options.tmux.position = lib.mkOption {
    type = lib.types.nonEmptyStr;
    default = "top";
  };

  config = {
    # Set default enable values for all available plugins
    tmux.pluginSettings = lib.mapAttrs (name: plugin: {
      enable = lib.mkDefault plugin.defaultEnable;
    }) availablePlugins;

    home.sessionVariables = {
      TMUXP_CONFIGDIR = "${config.xdg.configHome}/tmux/tmuxp";
    };

    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      terminal = "tmux-256color";
      historyLimit = 1000;
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      shortcut = config.tmux.shortcut;
      tmuxp.enable = config.tmux.tmuxp.enable;
      extraConfig = (import ./config.nix { inherit config lib; }).config;
      plugins = enabledPlugins;
    }
    // lib.optionalAttrs config.tmux.systemShell.enable {
      shell = "/usr/bin/zsh";
    };

    home.activation.extractTmuxp =
      lib.mkIf
        (config.tmux.tmuxp.enable && builtins.pathExists config.sops.secrets.tmuxp.path)
        (
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ${pkgs.python3.withPackages (ps: [ ps.pyyaml ])}/bin/python3 << 'EOF'
            import yaml
            import os
            import sys
            secret_path = "${config.sops.secrets.tmuxp.path}";
            output_dir = "${config.xdg.configHome}/tmux/tmuxp";
            os.makedirs(output_dir, exist_ok=True)
            if not os.path.exists(secret_path):
              print(f"Warning: secret not found: {secret_path}")
              sys.exit(0)
            try:
              with open(secret_path, 'r') as f:
                tmuxp_data = yaml.safe_load(f)
              for name, content in tmuxp_data.items():
                file_path = os.path.join(output_dir, f"{name}.yaml")
                try:
                  with open(file_path, 'w') as f:
                      yaml.dump(content, f)
                  os.chmod(file_path, 0o444)
                except PermissionError:
                  print(f"Warning: Could not write {file_path}, skipping.")
            except Exception as e:
              print(f"Warning: Failed: {e}")
              sys.exit(0)
            EOF
          ''
        );
  };
}
