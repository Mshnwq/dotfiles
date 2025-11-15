# dotfiles/flake.nix
{
  description = "Reusable dotfiles configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { ... }:
    {
      homeModules = {
        vim = import ./config/home-manager/programs/vim.nix;
      };
    };
}
