{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.nix4nvchad.homeManagerModules.nvchad
  ];
  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      dockerfile-language-server-nodejs
      docker-compose-language-service
      (python3.withPackages(ps: with ps; [
        #python-lsp-server
        isort
        flake8
        #watchdog
      ]))
    ];
  };
  #home.packages = with pkgs; [
    #python313Packages.watchdog
  #];

  # Home Manager activation to install dclint globally via npm
  #home.activation.installDclint = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
  #  command -v dclint >/dev/null || ${pkgs.nodejs}/bin/npm install -g dclint
  #'';
}
