# programs/hypr.nix
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hyprConfDir = "${config.xdg.configHome}/hypr/conf.d";
in
{
  options.hypr.hyprWorkspaceLayouts.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable hyprWorkspaceLayouts plugin";
  };

  config = {
    home.packages = with pkgs; [
      swww
      grim
      slurp
      swappy
      waybar
      niflveil # mine
      hypridle
      # hyprlock TODO: broken
      hyprsunset
      hyprpicker
      libinput-gestures
      # TODO: quickshell
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = config.lib.nixGL.wrap hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
      plugins = lib.mkIf config.hypr.hyprWorkspaceLayouts.enable [
        inputs.hyprWorkspaceLayouts.packages.${pkgs.system}.default
      ];
      extraConfig =
        let
          layoutConfigContent =
            builtins.readFile
              config.sops.secrets."keyboard-conf".path;
          # Parse lines and extract layout codes (values after =)
          parseLayouts =
            content:
            let
              lines = lib.splitString "\n" content;
              # Filter out empty lines and comments
              validLines = builtins.filter (
                line: line != "" && !(lib.hasPrefix "#" (lib.trim line))
              ) lines;
              # Extract the part after = and trim whitespace
              extractCode =
                line:
                let
                  parts = lib.splitString "=" line;
                in
                if builtins.length parts >= 2 then lib.trim (builtins.elemAt parts 1) else "";
              codes = map extractCode validLines;
              # Filter out empty codes
              validCodes = builtins.filter (code: code != "") codes;
            in
            lib.concatStringsSep "," validCodes;

          kbLayouts = parseLayouts layoutConfigContent;
        in
        lib.concatStringsSep "\n" [
          ''
            exec-once = dbus-update-activation-environment --systemd --all
            exec-once = /usr/bin/lxpolkit
            source = ${hyprConfDir}/autostart.conf
            source = ${hyprConfDir}/env.conf
            source = ${hyprConfDir}/general.conf
            source = ${hyprConfDir}/input.conf
            source = ${hyprConfDir}/keybindings.conf
            source = ${hyprConfDir}/layouts.conf
            source = ${hyprConfDir}/monitors.conf
            source = ${hyprConfDir}/rules.conf
            input {
                kb_layout=${kbLayouts}
            }
          ''
          (
            if config.hypr.hyprWorkspaceLayouts.enable then
              "source = ${hyprConfDir}/workspaceLayouts.conf"
            else
              ""
          )
        ];
    };

    home.file."${hyprConfDir}/workspaceLayouts.conf" =
      lib.mkIf config.hypr.hyprWorkspaceLayouts.enable
        {
          force = true;
          text = ''
            plugin {
              wslayout {
                default_layout=dwindle
              }
            }
            general {
              layout=workspacelayout
            }
          '';
        };

    sops.secrets = {
      keyboard-conf = {
        mode = "0400";
        path = "${config.xdg.configHome}/keyboard_layouts.conf";
      };
    };
  };
}
