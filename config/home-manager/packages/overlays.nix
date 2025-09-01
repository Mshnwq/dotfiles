lib: {
  # INDIVIDUAL PACKAGES #

  # myfox = pkgs: _: {
  #   myfox = pkgs.callPackage ./myfox.nix { inherit lib; };
  # };

  # PACKAGE SETS #

  firefox-extensions = pkgs: _: {
    firefox-extensions =
      pkgs.callPackages ./firefox-extensions.nix { inherit lib; };
  };
}
