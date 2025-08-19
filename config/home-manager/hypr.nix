{ config, pkgs, lib, ... }: {
  # imports = [ inputs.hyprnix.homeManagerModules.default ];
  home.packages = [
    pkgs.nixgl.nixGLDefault
    pkgs.hyprland
    pkgs.waybar
    # pkgs.eww
    pkgs.rofi-wayland
    # pkgs.dunst
    pkgs.kitty
    # pkgs.alacritty
    pkgs.swww
    pkgs.cliphist
  ];
}
