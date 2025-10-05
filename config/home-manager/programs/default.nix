args@{
  self,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
(lib.mapAttrs (_: expr: if lib.isFunction expr then expr args else expr) (
  lib.importDir' ./. "default.nix"
))
// {
  obs-studio = {
    programs.obs-studio.enable = true;
    programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-move-transition
      obs-backgroundremoval
    ];
    # needed for screen selection on wayland
    home.packages = [ pkgs.slurp ];
  };
  devenv = {
    home.packages = [
      pkgs.direnv
      inputs.devenv.packages.x86_64-linux.devenv
    ];
  };
  # TODO: hide share one
  keepassxc = {
    xdg.desktopEntries.keepassxc-nix = {
      name = "KeePassXC (nix)";
      exec = "env QT_SCALE_FACTOR=0.75 /usr/bin/keepassxc";
      icon = "keepassxc";
      categories = [ "Utility" ];
      type = "Application";
      startupNotify = true;
    };
  };
}
