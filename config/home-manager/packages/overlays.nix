# packages/overlays.nix
lib: final: prev: {
  shyfox = final.callPackage ./shyfox.nix { };
}
