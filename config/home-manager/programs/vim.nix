# programs/vim.nix
{
  pkgs,
  ...
}:
{
  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim;
    extraConfig = ''
      set viminfo+=n~/.config/viminfo
      autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
    '';
  };
  # https://github.com/vim/vim/issues/5157
  # home.file.".local/bin/vim" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env sh
  #     env -u XDG_SEAT -a vim ${config.programs.vim.package}/bin/vim "$@"
  #   '';
  # };
}
