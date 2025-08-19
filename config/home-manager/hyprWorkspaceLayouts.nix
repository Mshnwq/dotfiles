{ lib
, fetchFromGitHub
, hyprland
, hyprlandPlugins
, pkg-config
, gcc
}:

hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprWorkspaceLayouts";
  version = "0.50.1";

  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprWorkspaceLayouts";
    # NOTE: must match hyprland version and incluse commit pin in hyprpm.toml
    # https://github.com/zakk4223/hyprWorkspaceLayouts/issues/27
    # rev = "760df97c3a9ba3991419a2885a4aa69503a599f1";
    hash = "sha256-aKsmvyhjlnHrVu4R25AJ4xB4B1mhgBL1Jdl106ItqHc=";
    rev = "d74fa07f4484e7934a26c26cdbe168533451935d";
    hash = "sha256-1dxRcryNRh0zPiuO5EusPY0Qazh6Ogca41C+/gvs15g=";
  };

  nativeBuildInputs = [ pkg-config gcc ];
  buildInputs = [ ]; # Hyprland + deps already provided by mkHyprlandPlugin

  buildPhase = ''
    g++ -shared -Wall -fPIC --no-gnu-unique \
      ./main.cpp ./workspaceLayout.cpp -g -std=c++23 -DWLR_USE_UNSTABLE \
      `pkg-config --cflags pixman-1 libdrm wayland-server hyprland` \
      -o hyprWorkspaceLayouts.so
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp hyprWorkspaceLayouts.so $out/lib/
  '';

  meta = {
    homepage = "https://github.com/zakk4223/hyprWorkspaceLayouts";
    description = "Hyprland plugin providing per-workspace tiling layouts";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
