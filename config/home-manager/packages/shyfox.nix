{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation (self: {
  pname = "shyfox";
  version = "1";
  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "ShyFox";
    rev = "eb69afbe4709b7c6d3d7d3271ca9fd9ce52b285b";
    hash = "sha256-f7us6rcBYSsPFuX0+Tq5FYeIwtbWKNqCb8CcVdg+l1M=";
  };
  installPhase = ''
    mkdir $out
    cp -r $src/chrome -T $out
  '';
})
