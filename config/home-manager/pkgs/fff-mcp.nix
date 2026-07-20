# pkgs/fff-mcp.nix
{
  pkgs,
  ...
}:
let
  version = "0.10.0"; # bump alongside fff releases
in
pkgs.rustPlatform.buildRustPackage {
  pname = "fff-mcp";
  version = version;
  src = pkgs.fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff";
    rev = "v${version}";
    hash = "sha256-nrstsxOxHTeSKkqpvyxdzyypfHU6wZBQpvNnCfjh9s4=";
  };
  cargoHash = "sha256-Nlf2Bxwe5KvZF0unpeK/mMFmv4NM+IKPpFOopXoNRxU=";
  cargoBuildFlags = [
    "-p"
    "fff-mcp"
  ];
  buildAndTestSubdir = "crates/fff-mcp";
  doCheck = false;
}
