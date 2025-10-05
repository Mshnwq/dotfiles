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
      programs.pass
      programs.auto
      programs.music
      programs.shell
      programs.tmux
      programs.yazi
      programs.pywal
      programs.rust
      programs.infra
      programs.mime
      programs.hypr
      programs.home
      programs.flat
      # programs.discord.stable
      programs.discord.canary
      programs.keepassxc
    ];
}
