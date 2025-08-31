{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation (self: {
  pname = "shyfox";
  version = "";
  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "ShyFox";
    rev = "main";
    hash = "";
  };
  installPhase = ''
    mkdir $out
    cp -r $src/chrome -T $out
  '';
})
