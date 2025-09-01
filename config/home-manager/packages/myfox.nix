{stdenv, fetchFromGithub, ...}:

stdenv.mkDerivation {
  pname = "myfox";
  version = "git";

  src = ;

  installPhase = ''
    mkdir -p $out/chrome
    cp -r chrome/* $out/chrome
  '';
}
