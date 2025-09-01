lib: packageOverlays:
lib.updates [
  # Include all overlays from the current directory
  # (excluding `default.nix` as it is not an overlay).
  (lib.importDir' ./. "default.nix")
  # Also include each package overlay, as it is named.
  packageOverlays
  {
    default = lib.composeManyExtensions (lib.attrValues packageOverlays);
    # lib = pkgs: _: import ../overlays/lib.nix pkgs;
  }
]
