{
  ...
}:
{
  programs.obsidian = {
    enable = true;
  };
  xdg.desktopEntries.obsidian-nix = {
    name = "Obsidian (nix)";
    exec = "Obsidian %u";
    icon = "obsidian";
    categories = [ "Utility" ];
    type = "Application";
    startupNotify = true;
  };
  # Custom wrapper for Obsidian
  home.file.".local/bin/Obsidian".text = ''
    #!/usr/bin/env bash
    exec nixGLIntel obsidian "$@" --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations
  '';
  home.file.".local/bin/Obsidian".executable = true;
}
