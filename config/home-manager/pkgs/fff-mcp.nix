# overlays/fff-mcp.nix
{
  pkgs,
  ...
}:
let
  version = "0.9.6"; # bump alongside fff releases
in
pkgs.rustPlatform.buildRustPackage {
  pname = "fff-mcp";
  version = version;
  src = pkgs.fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # nix will tell you the right one on first build
  };
  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # same, fill in after first build failure
  # it's a cargo workspace; only build the mcp server binary
  cargoBuildFlags = [
    "-p"
    "fff-mcp"
  ];
  buildAndTestSubdir = "crates/fff-mcp";
  # skip the workspace's other crates' tests/deps you don't need (nvim lua bindings, C ABI, etc.)
  doCheck = false;
}
