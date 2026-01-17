# pkgs/overlays.nix
{ lib, inputs }:
final: prev: {
  niflveil = final.callPackage ./niflveil.nix { };
  shyfox = final.callPackage ./shyfox.nix { };
  guitar = final.callPackage ./guitar.nix { };
  guitarpro = final.callPackage ./guitarpro.nix {
    wine = final.wineWowPackages.stableFull;
    makeDesktopItem = final.makeDesktopItem;
    copyDesktopItems = final.copyDesktopItems;
    makeDesktopIcon = inputs.erosanix.lib.${final.system}.makeDesktopIcon;
    copyDesktopIcons = inputs.erosanix.lib.${final.system}.copyDesktopIcons;
    mkWindowsAppNoCC = inputs.erosanix.lib.${final.system}.mkWindowsAppNoCC;
  };
}
