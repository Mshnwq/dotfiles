{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    anki
  ];
  # xdg.desktopEntries.anki-nix = {
  #   name = "Anki (nix)";
  #   exec = "nixGL anki %u";
  #   icon = "anki";
  #   categories = [ "Utility" ];
  #   type = "Application";
  #   startupNotify = true;
  # };
  # # Custom wrapper for anki
  # home.file.".local/bin/Anki".text = ''
  #   #!/usr/bin/env bash
  #   exec nixGL anki "$@"
  # '';
  # home.file.".local/bin/Anki".executable = true;
}
