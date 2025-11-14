# .dotfiles/flake.nix
{
  description = "Reusable dotfiles configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { ... }:
    {
      # modules I can export to be used by other machines
      homeModules = {
        vim = import ./config/home-manager/programs/vim.nix;
      };
    };
}
