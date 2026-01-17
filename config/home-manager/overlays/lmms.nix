# overlays/lmms.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/audio/lmms/default.nix#L90
final: prev:
let
  lmmx3Theme = final.fetchFromGitHub {
    owner = "Yulljie";
    repo = "LMMX3";
    rev = "f41a12afefe976e3d4b33dceba4590395ec3d32b";
    hash = "sha256-SLMYsrnMdE8UNToTScSn3dHAASHx0jx2gW/iAXnNNqo=";
  };
in
{
  lmms = prev.lmms.overrideAttrs (oldAttrs: {
    version = "1.3.0-alpha.1";
    src = final.fetchFromGitHub {
      owner = "LMMS";
      repo = "lmms";
      rev = "bfa04c987d72454b9005b491cfb8f3fdeb58a170";
      hash = "sha256-OunRllU7+VHPgknPvmHOCeDVQQtyLE3BqykWkXHN5F4=";
      fetchSubmodules = true;
    };
    patches = [ ];
    postInstall = (oldAttrs.postInstall or "") + ''
      rm -rf $out/share/lmms/themes/default
      cp -r ${lmmx3Theme}/LMMX3 $out/share/lmms/themes/default
    '';
  });
}
