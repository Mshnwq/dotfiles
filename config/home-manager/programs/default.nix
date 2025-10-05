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
  # automation tools
  auto = {
    home.packages = with pkgs; [
      yt-dlp
      gallery-dl
      jdupes
      nurl
      buku
      nmap
    ];
  };
}
