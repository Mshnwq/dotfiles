# programs/vim.nix
{
  config,
  pkgs,
  ...
}:
{
  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim-full;
    extraConfig = ''
      set viminfo+=n~/.config/viminfo
      autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
    '';
  };
  # https://github.com/vim/vim/issues/5157
  home.file.".local/bin/vim" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      unset XDG_SEAT
      exec ${config.programs.vim.package}/bin/vim "$@"
    '';
  };
}
