# overlays/highlight.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/text/highlight/default.nix#L75
final: prev: {
  highlight = prev.highlight.overrideAttrs (oldAttrs: {
    version = "4.16";
    src = final.fetchFromGitLab {
      owner = "saalen";
      repo = "highlight";
      rev = "7a3ab0e20e84ef304f483094d2ab783e8c93be0a";
      hash = "sha256-SAOlW2IaYY2GzQ+1FClqm62pcxdtf1cow2R4MRS/2Vg=";
    };
  });
}
