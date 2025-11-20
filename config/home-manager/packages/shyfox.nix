# packages/shyfox.nix
{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "shyfox";
  version = "250e8ef";
  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "shyfox";
    rev = "250e8efbf446c3d242487bc38c4a768f2c5be812";
    hash = "sha256-oJDZN6dSOHEjLyVA9U8YkyjPO0xU37WV5gN5QO+1V8s=";
  };
  installPhase = ''
    mkdir $out
    cp -r $src -T $out
  '';
}
