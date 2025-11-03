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
      buku
      nmap
    ];
  };

  # keyboard
  qmk = {
    home.packages = with pkgs; [
      vial
    ];
  };

  # language
  anki = {
    home.packages = with pkgs; [
      anki
    ];
  };
}
