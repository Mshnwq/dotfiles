# pkgs/mermaid-ascii.nix
{
  pkgs,
  ...
}:
pkgs.buildGoModule {
  pname = "mermaid-ascii";
  version = "1.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "AlexanderGrooff";
    repo = "mermaid-ascii";
    rev = "b5d02c35decfab219bd6cc79094b117d8079bd63";
    hash = "sha256-bFqlMwBfvm75aKiUU1GZadGtMWppCabwdvguMzK/KBo=";
  };
  vendorHash = "sha256-aB9sbTtlHbptM2995jizGFtSmEIg3i8zWkXz1zzbIek=";
}
