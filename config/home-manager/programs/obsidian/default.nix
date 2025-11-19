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
}
