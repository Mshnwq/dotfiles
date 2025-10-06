{ config, pkgs, ... }:
{
  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim-full;
    extraConfig = ''
      " Normal mode mappings
      nnoremap <silent> S A
      nnoremap <silent> A I
      nnoremap <silent> s a
      nnoremap <silent> a i

      nnoremap <silent> E W
      nnoremap <silent> e w
      nnoremap <silent> W B
      nnoremap <silent> w b

      nnoremap <silent> J L
      nnoremap <silent> K H
      nnoremap <silent> L $
      nnoremap <silent> H ^

      " Visual mode mappings
      vnoremap <silent> E W
      vnoremap <silent> e w
      vnoremap <silent> W B
      vnoremap <silent> w b

      vnoremap <silent> J L
      vnoremap <silent> K H
      vnoremap <silent> L $
      vnoremap <silent> H ^

      autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
    '';
    # plugins = with pkgs.vimPlugins; [
    #   vim-wayland-clipboard
    # ];
  };
  # https://github.com/vim/vim/issues/5157
  home.file.".local/bin/vim".text = ''
    #!/usr/bin/env bash
    unset XDG_SEAT
    exec ${config.programs.vim.package}/bin/vim "$@"
  '';
  home.file.".local/bin/vim".executable = true;
  # vim binary order nix > user > system
}

# " call plug#begin('~/.vim/plugged')
# " Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
# " let g:Hexokinase_highlighters = [ 'backgroundfull' ]
# " call plug#end()
# autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
# nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
# nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
