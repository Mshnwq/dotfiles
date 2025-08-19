{ pkgs, ... }: {
  home.packages = [
    pkgs.yt-dlp
    pkgs.gallery-dl
    pkgs.jdupes
    pkgs.nurl
    # https://github.com/pnpm/pnpm/pull/4522
    # https://github.com/pnpm/pnpm/pull/3873
    # https://github.com/pnpm/pnpm/issues/2574
  ];
}
