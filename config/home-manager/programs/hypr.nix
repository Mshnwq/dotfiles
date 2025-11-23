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
      hyprsunset
      hyprpicker
      libinput-gestures
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = config.lib.nixGL.wrap hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
      plugins = lib.mkIf config.hypr.hyprWorkspaceLayouts.enable [
        inputs.hyprWorkspaceLayouts.packages.${pkgs.system}.default
      ];
      extraConfig = lib.concatStringsSep "\n" [
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
  };
}
