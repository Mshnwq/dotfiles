args@{ self, config, lib, inputs, pkgs, ... }: {

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  xdg.desktopEntries.firefox-nix = {
    name = "Firefox (nix)";
    exec = "env MOZ_USE_XINPUT2=1 nixGL firefox %u";
    icon = "firefox";
    categories = [ "Network" "WebBrowser" ];
    type = "Application";
    startupNotify = true;
    mimeType = [
      "text/html" "text/xml" "application/xhtml+xml"
      "x-scheme-handler/http" "x-scheme-handler/https"
    ];
  };

  # Custom wrapper for firefox 
  home.file.".local/bin/firefox".text = ''
    #!/usr/bin/env bash
    exec env MOZ_USE_XINPUT2=1 nixGL ~/.nix-profile/bin/firefox "$@"
  '';
  home.file.".local/bin/firefox".executable = true;

  ##########################
  ### PACKAGES & MODULES ###
  ##########################

  imports = let
    user = lib.importDir' ./. "user.nix";
    programs = user.programs args;
  in [

    ### WEB BROWSERS ###
    programs.firefox

    ### DOCUMENT/FILETYPE HANDLERS ###
    # programs.zathura
  ];
}
