pkgs:
let
  inherit (pkgs) lib;
  # Build a Firefox extension from an XPI file...
  buildFirefoxXpiAddon = lib.makeOverridable ({
    # Required:
    pname, version, addonId, url, hash, meta,
    # Override:
    stdenv ? pkgs.stdenv, fetchurl ? pkgs.fetchurl,
    #
    ... }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url hash; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });
in {
  inherit buildFirefoxXpiAddon;
}
