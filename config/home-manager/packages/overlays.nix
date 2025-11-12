# packages/overlays.nix
lib: final: prev: {
  shyfox = final.callPackage ./shyfox.nix { };
  # cursors = pkgs: _: { cursors = pkgs.callPackage ./cursors.nix { }; };
}
