lib: {
  # INDIVIDUAL PACKAGES #

  shyfox = pkgs: _: {
    shyfox = pkgs.callPackage ./shyfox.nix { inherit lib; };
  };

  # PACKAGE SETS #

}
