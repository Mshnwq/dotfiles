{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    direnv
    # devenv
    neovim
    nodejs
    python313Packages.flake8
    python313Packages.isort
    python313Packages.watchdog
  ];

  # Home Manager activation to install dclint globally via npm
  home.activation.installDclint = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
    command -v dclint >/dev/null || ${pkgs.nodejs}/bin/npm install -g dclint
  '';
}
