{ config, pkgs, lib, hyprland, ... }: {
  home.packages = [
    pkgs.grim
    pkgs.swappy
    pkgs.gcc
    pkgs.libinput-gestures  
    # grep -E '^input:' /usr/lib/group | sudo tee -a /etc/group
    # sudo usermod -aG input $USER && reboot
    # or ujust add-user-to-input-group
  ];
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
      mkdir -p "$HOME/.local/bin"
      cp target/release/niflveil "$HOME/.local/bin/"
    fi
  '';
}
