{
  lib,
  pkgs,
  ...
}:
let
  plugins = pkgs.callPackage ./plugins.nix { inherit pkgs; };
in
{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = with plugins; [
        pywalPlugin
        advancedUri
      ];
    };
    vaults = {
      "Home" = {
        enable = true;
        target = "Documents/Obsidian/Home";
      };
      "Dummy" = {
        enable = true;
        target = "Documents/Obsidian/Dummy";
      };
    };
  };
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    exec = "Obsidian %u";
    icon = "obsidian";
    categories = [ "Utility" ];
    type = "Application";
    startupNotify = true;
    mimeType = [
      "x-scheme-handler/obsidian"
    ];
  };
  imports = [
    (lib.nixgl.mkNixGLWrapper {
      name = "Obsidian";
      command = "obsidian";
      nixGLVariant = "nixGLIntel";
      extraArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations";
    })
  ];
}
