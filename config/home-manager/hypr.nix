{ config, pkgs, lib, ... }: {
  # imports = [ inputs.hyprnix.homeManagerModules.default ];
  home.packages = [
    pkgs.nixgl.auto.nixGLDefault  # NOTE: run with --impure flag
    pkgs.hyprland
    pkgs.waybar
    # pkgs.eww
    pkgs.rofi-wayland
    pkgs.dunst
    pkgs.kitty
    pkgs.alacritty
    pkgs.swww
    pkgs.cliphist
  ];
  # Custom wrapper for Hyprland
  home.file.".local/bin/Hyprland-Nix".text = ''
    ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.hyprland}/bin/Hyprland
  '';
  home.file.".local/bin/Hyprland-Nix".executable = true;
}
