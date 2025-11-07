{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "shyfox";
  version = "6032da3";
  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "cursors";
    rev = "6032da35971b9cbc2d478b5e4a95d2488a1529e0";
    hash = "sha256-/N4VGQzkr4rV6/C2Y3MPX3jqlNMUxdeBfpQNeH3p9E4=";
  };
  installPhase = ''
    mkdir $out
  '';
}
# catppuccin-whiskers # no need cursors has a *.nix
