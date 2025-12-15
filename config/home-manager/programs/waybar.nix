# programs/waybar.nix
{
  pkgs,
  lib,
  ...
}:
{
  options.waybar.cava.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable hyprWorkspaceLayouts plugin";
  };

  config = {
    home.packages = with pkgs; [
      waybar
    ];
    programs.waybar = {
      enable = true;
    };
  };
}
