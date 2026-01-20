# dotfiles/flake.nix
{
  description = "Reusable dotfiles configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { ... }:
    {
      homeModules = builtins.listToAttrs (
        builtins.map
          (name: {
            inherit name;
            value = import ./config/home-manager/programs/${name}/default.nix;
          })
          [
            "zsh"
            "yazi"
            "tmux"
          ]
      );
    };
}
