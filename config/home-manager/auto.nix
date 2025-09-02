{ pkgs, ... }: {
  home.packages = [
    pkgs.yt-dlp
    pkgs.gallery-dl
    pkgs.jdupes
    pkgs.nurl
  ];
}
