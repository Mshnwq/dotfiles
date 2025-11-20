# programs/tmux/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
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

  options.programs.tmuxp.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable tmuxp";
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
      tmuxp.enable = config.programs.tmuxp.enable;
      extraConfig = import ./config.nix { };
      plugins = enabledPlugins;
    };

    home.activation.extractTmuxp =
      lib.mkIf (config.programs.tmuxp.enable && inputs.useSops)
        (
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ${pkgs.python3.withPackages (ps: [ ps.pyyaml ])}/bin/python3 << 'EOF'
            import yaml
            import os

            secret_path = "${config.sops.secrets.tmuxp.path}";
            output_dir = "${config.xdg.configHome}/tmux/tmuxp";

            os.makedirs(output_dir, exist_ok=True)

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
            EOF
          ''
        );
  };
}
