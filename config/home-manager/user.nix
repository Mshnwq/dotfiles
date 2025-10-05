args@{
  self,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports =
    let
      user = lib.importDir' ./. "user.nix";
      programs = user.programs args;
    in
    [
      programs.devenv
      programs.mpv
      programs.vim
      programs.neovim
      programs.firefox
      # programs.discord.stable
      programs.discord.canary
      programs.keepassxc
    ];
}
