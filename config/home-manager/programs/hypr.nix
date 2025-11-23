# programs/hypr.nix
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
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
    plugins = [ inputs.hyprWorkspaceLayouts.packages.${pkgs.system}.default ];
    extraConfig = ''
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = /usr/bin/lxpolkit
      source = ~/.config/hypr/conf.d/autostart.conf
      source = ~/.config/hypr/conf.d/env.conf
      source = ~/.config/hypr/conf.d/general.conf
      source = ~/.config/hypr/conf.d/input.conf
      source = ~/.config/hypr/conf.d/keybindings.conf
      source = ~/.config/hypr/conf.d/layouts.conf
      source = ~/.config/hypr/conf.d/monitors.conf
      source = ~/.config/hypr/conf.d/rules.conf
      # TODO: merge is plugin
      source = ~/.config/hypr/conf.d/workspaceLayouts.conf
    '';
  };
}
