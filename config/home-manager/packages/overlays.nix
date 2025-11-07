# packages/overlays.nix
lib: final: prev: {
  shyfox = final.callPackage ./shyfox.nix { };
  # cursors = pkgs: _: { cursors = pkgs.callPackage ./cursors.nix { }; };
}
# discord-recolor-theme = pkgs: _: {
#   discord-recolor-theme = pkgs.callPackage ./discord-recolor-theme.nix { };
# };

# PACKAGE SETS #

# zsh-plugins = pkgs: _: {
#   zsh-plugins = pkgs.callPackages ./zsh-plugins.nix { inherit lib; };
# };
#
# firefox-extensions = pkgs: _: {
#   firefox-extensions =
#     pkgs.callPackages ./firefox-extensions.nix { inherit lib; };
# };
