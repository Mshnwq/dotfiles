{ config, pkgs, lib, ... }: let
  hyprWorkspaceLayouts = pkgs.callPackage ./lib/hyprWorkspaceLayouts.nix {};
in {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      (pkgs.callPackage ./lib/hyprWorkspaceLayouts.nix { })
    ];
  };
  home.packages = [
    # hyprWorkspaceLayouts
    pkgs.nixgl.auto.nixGLDefault  # NOTE: run with --impure flag
    pkgs.hyprland
    pkgs.hyprsunset
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
    ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.hyprland}/bin/Hyprland
  '';
  home.file.".local/bin/Hyprland-Nix".executable = true;
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
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      # Force gcc from Nix
      export RUSTFLAGS="-C linker=${pkgs.gcc}/bin/cc"
      ${pkgs.cargo}/bin/cargo build --release -j 2
      cp target/release/niflveil "$HOME/.local/bin/"
    fi
  '';
  home.file."${config.xdg.configHome}/hypr/workspaceLayouts.conf".text = ''
    # exec-once = hyprctl plugin load ~/.nix-profile/lib/workspaceLayoutPlugin.so
    plugin {
        wslayout {
            default_layout=dwindle
        }
    }
    general {
        layout=workspacelayout
    }
  '';
}
