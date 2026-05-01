# overlays/yt-dlp.nix
# https://github.com/NixOS/nixpkgs/blob/1c3fe55ad329cbcb28471bb30f05c9827f724c76/pkgs/by-name/yt/yt-dlp/package.nix#L40
# Just to get rid of stup Deno
final: prev: {
  yt-dlp = prev.yt-dlp.override { javascriptSupport = false; };
}
