{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "hyprWorkspaceLayouts";
  version = "0.50.1";

  src = pkgs.fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprWorkspaceLayouts";
    rev = "760df97";
    hash = "sha256-";
  };

  nativeBuildInputs = [ pkgs.pkg-config pkgs.gcc pkgs.makeWrapper ];
  buildInputs = [ pkgs.hyprland pkgs.wlroots pkgs.libdrm pkgs.libinput pkgs.xorg.libX11 ];

  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp workspaceLayoutPlugin.so $out/lib/
  '';
}
