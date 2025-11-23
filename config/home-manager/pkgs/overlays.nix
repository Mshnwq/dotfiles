# pkgs/overlays.nix
{ lib, inputs }:
final: prev: {
  shyfox = final.callPackage ./shyfox.nix { };
  niflveil = final.callPackage ./niflveil.nix { };
  guitarpro = final.callPackage ./guitarpro.nix {
    wine = final.wineWowPackages.stableFull;
    makeDesktopItem = final.makeDesktopItem;
    copyDesktopItems = final.copyDesktopItems;
    makeDesktopIcon = inputs.erosanix.lib.${final.system}.makeDesktopIcon;
    copyDesktopIcons = inputs.erosanix.lib.${final.system}.copyDesktopIcons;
    mkWindowsAppNoCC = inputs.erosanix.lib.${final.system}.mkWindowsAppNoCC;
  };
}
