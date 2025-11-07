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
    # plugins = with pkgs.vimPlugins; [
    #   vim-wayland-clipboard
    # ];
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
  # vim binary order nix > user > system
}

# " call plug#begin('~/.vim/plugged')
# " Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
# " let g:Hexokinase_highlighters = [ 'backgroundfull' ]
# " call plug#end()
# autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
# nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
# nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
