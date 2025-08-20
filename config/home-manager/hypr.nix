{ config, pkgs, lib, hyprland, ... }:  {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # plugins = [
    #   (pkgs.callPackage ./hyprWorkspaceLayouts.nix {})
    # ];
      # source = ${config.xdg.configHome}/hypr/workspaceLayouts.conf
    extraConfig = ''
      source = ${config.xdg.configHome}/hypr/hyprextra.conf
    '';
  };

  home.packages = [
    pkgs.nixgl.auto.nixGLDefault  # NOTE: run with --impure flag
    # pkgs.hyprsunset
    pkgs.waybar
    # pkgs.eww
    pkgs.rofi-wayland
    pkgs.dunst
    pkgs.kitty
    pkgs.alacritty
    pkgs.swww
    pkgs.cliphist
    pkgs.grim
    pkgs.swappy
    pkgs.gcc
  ];

  # Custom wrapper for Hyprland
  home.file.".local/bin/Hyprland-Nix".text = ''
    ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL \
      ${hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/Hyprland
  '';
    # ${pkgs.hyprland}/bin/Hyprland
  home.file.".local/bin/Hyprland-Nix".executable = true;

  home.file."${config.xdg.configHome}/hypr/workspaceLayouts.conf".text = ''
    plugin {
      wslayout {
        default_layout=dwindle
      }
    }
    general {
      layout=workspacelayout
    }
  '';

  home.activation.buildNiflVeil = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -x "$HOME/.local/bin/niflveil" ]; then
      echo ">>> Building NiflVeil (first time only)..."
      mkdir -p "$HOME/.build"
      for i in {1..3}; do
        /usr/bin/git clone https://github.com/Mauitron/NiflVeil.git "$HOME/.build/NiflVeil" && break
        rm -rf "$HOME/.build/NiflVeil"
        sleep 3
      done
      cd "$HOME/.build/NiflVeil/niflveil" || exit 1
      sed -i '341c\        println!("{{\\"text\\":\\" \\",\\"class\\":\\"empty\\",\\"tooltip\\":\\"No minimized windows\\"}}");' src/main.rs
      # Force gcc from Nix
      export RUSTFLAGS="-C linker=${pkgs.gcc}/bin/cc"
      ${pkgs.cargo}/bin/cargo build --release -j 2
      cp target/release/niflveil "$HOME/.local/bin/"
    fi
  '';
}
