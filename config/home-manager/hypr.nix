{ config, pkgs, lib, ... }: {
  # imports = [ inputs.hyprnix.homeManagerModules.default ];
  home.packages = [
    pkgs.nixgl.auto.nixGLDefault  # NOTE: run with --impure flag
    pkgs.hyprland
    pkgs.waybar
    # pkgs.eww
    pkgs.rofi-wayland
    pkgs.dunst
    pkgs.kitty
    pkgs.alacritty
    pkgs.swww
    pkgs.cliphist
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
      cargo build --release -j 2
      cp target/release/niflveil "$HOME/.local/bin/"
    fi
  '';
}
