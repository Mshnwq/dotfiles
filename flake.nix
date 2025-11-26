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
        zsh = import ./config/home-manager/programs/zsh/default.nix;
        yazi = import ./config/home-manager/programs/yazi/default.nix;
        tmux = import ./config/home-manager/programs/tmux/default.nix;
        nvim = import ./config/home-manager/programs/neovim/default.nix;
        neovim = import ./config/home-manager/programs/neovim/default.nix;
      };
    };
}
