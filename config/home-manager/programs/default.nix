# programs/default.nix
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
    # DIRENV_LOG_FORMAT = "";
  };

  # automation tools
  auto = {
    home.packages = with pkgs; [
      gallery-dl
      yt-dlp
      rclone
      jdupes
      nmap
      buku
      # --import bookmarks.db
    ];
  };

  # language
  anki = {
    home.packages = with pkgs; [
      anki
    ];
    # ANKI_WAYLAND = "1";
  };
}
