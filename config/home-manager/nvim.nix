{ config, pkgs, lib, ... }: {
  home.packages = [
    pkgs.direnv
    pkgs.neovim
    pkgs.nodejs
    pkgs.python313Packages.flake8
    pkgs.python313Packages.isort
    pkgs.python313Packages.watchdog
  ];

  # Home Manager activation to install dclint globally via npm
  home.activation.installDclint = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export NPM_CONFIG_PREFIX="$HOME/.local"
    command -v dclint >/dev/null || ${pkgs.nodejs}/bin/npm install -g dclint
  '';
}
