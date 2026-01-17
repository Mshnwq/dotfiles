# pkgs/guitar.nix
{ pkgs, ... }:
let
  version = "0.1.39";
in
pkgs.rustPlatform.buildRustPackage {
  pname = "guitar";
  version = version;
  src = pkgs.fetchFromGitHub {
    owner = "asinglebit";
    repo = "guitar";
    rev = "v${version}";
    hash = "sha256-zo0Flcxr7wxiHNvHGvMFFf28kngO5tfyFQSBL2u2jPY=";
  };
  cargoHash = "sha256-rWNihNr5N9mIHfKCjOXJVCDMApOmvKg2S80ieTGe4KU=";
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];
}
