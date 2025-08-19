# { lib, stdenv, fetchFromGitHub, pkg-config, gcc
# , hyprland, hyprgraphics, hyprutils, hyprlang,
# aquamarine, pixman, wayland, wlroots, cairo,
# libdrm, libinput, libxkbcommon, libGL }:
# stdenv.mkDerivation {
#   pname = "hyprWorkspaceLayouts";
#   version = "0.50.1";
#   src = fetchFromGitHub {
#     owner = "zakk4223";
#     repo = "hyprWorkspaceLayouts";
#     rev = "760df97c3a9ba3991419a2885a4aa69503a599f1";
#     hash = "sha256-aKsmvyhjlnHrVu4R25AJ4xB4B1mhgBL1Jdl106ItqHc=";
#   };
#   nativeBuildInputs = [ pkg-config gcc ];
#   buildInputs = [ hyprland hyprgraphics hyprutils hyprlang aquamarine cairo pixman wayland wlroots libdrm libinput libxkbcommon libGL ];
#   buildPhase = ''
#     g++ -shared -Wall -fPIC --no-gnu-unique \
#       ./main.cpp ./workspaceLayout.cpp -g -std=c++23 -DWLR_USE_UNSTABLE \
#       `pkg-config --cflags pixman-1 libdrm wayland-server hyprland` \
#       -o workspaceLayoutPlugin.so
#   '';
#   installPhase = ''
#     mkdir -p $out/lib
#     cp workspaceLayoutPlugin.so $out/lib/
#   '';
# }


{ lib
, fetchFromGitHub
, hyprland
, hyprlandPlugins
, cmake
}:

hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprWorkspaceLayouts";
  version = "0.50.1";

  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprWorkspaceLayouts";
    rev = "760df97c3a9ba3991419a2885a4aa69503a599f1";
    hash = "sha256-aKsmvyhjlnHrVu4R25AJ4xB4B1mhgBL1Jdl106ItqHc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # Hyprland and its deps are already passed in by mkHyprlandPlugin,
  # so you only add *extra* dependencies here if required.
  buildInputs = [ ];

  meta = {
    homepage = "https://github.com/zakk4223/hyprWorkspaceLayouts";
    description = "Hyprland plugin providing per-workspace tiling layouts";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
