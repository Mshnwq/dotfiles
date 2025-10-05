{
  config,
  pkgs,
  lib,
  ...
}:
{

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19" # for the rcc :(
  ];

  home.packages = with pkgs; [
    pywal16
    pywalfox-native # do pywalfox install
    highlight
    libsForQt5.full # bloat only for rcc :(
    catppuccin-whiskers # no need cursors has a *.nix
    kdePackages.qtstyleplugin-kvantum
    # TODO: automate this
    # Plasma Style: Utterly-Round (follows color scheme)
    # utterly-round-plasma-style # manually set
    # Window Decorations: Utterly-Round-Dark (also follows color scheme)
    # in kde settings
    # Set Application Style to Kvantum if not already
    # papirus-icon-theme  # cant use this beacuse it doesnt link to local icons
    papirus-folders # cli tool
    nerd-fonts.jetbrains-mono
    nerd-fonts.roboto-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
  ];

  home.activation.linkWalTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.configHome}/yazi"
    mkdir -p "${config.xdg.configHome}/kitty"
    mkdir -p "${config.xdg.configHome}/zathura"
    mkdir -p "${config.xdg.configHome}/waybar"
    mkdir -p "${config.xdg.configHome}/alacritty"
    mkdir -p "${config.xdg.configHome}/dunst"
    mkdir -p "${config.xdg.configHome}/cava"
    mkdir -p "${config.xdg.configHome}/rofi"
    mkdir -p "${config.xdg.configHome}/rmpc/themes"
    mkdir -p "${config.xdg.configHome}/btop/themes"
    mkdir -p "${config.xdg.configHome}/k9s/skins"

    ln -sf "${config.xdg.cacheHome}/wal/custom-yazi.toml" "${config.xdg.configHome}/yazi/theme.toml"
    ln -sf "${config.xdg.cacheHome}/wal/custom-kitty.conf" "${config.xdg.configHome}/kitty/custom-kitty.conf"
    ln -sf "${config.xdg.cacheHome}/wal/custom-tmux.conf" "${config.xdg.configHome}/tmux/pywal.conf"
    ln -sf "${config.xdg.cacheHome}/wal/colors-zathura" "${config.xdg.configHome}/zathura/zathurarc"
    ln -sf "${config.xdg.cacheHome}/wal/colors-waybar.css" "${config.xdg.configHome}/waybar/colors-waybar.css"
    ln -sf "${config.xdg.cacheHome}/wal/colors-alacritty.toml" "${config.xdg.configHome}/alacritty/colors-alacritty.toml"
    ln -sf "${config.xdg.cacheHome}/wal/custom-dunstrc" "${config.xdg.configHome}/dunst/dunstrc"
    ln -sf "${config.xdg.cacheHome}/wal/custom-cava" "${config.xdg.configHome}/cava/config"
    ln -sf "${config.xdg.cacheHome}/wal/custom-rofi.rasi" "${config.xdg.configHome}/rofi/shared.rasi"
    ln -sf "${config.xdg.cacheHome}/wal/custom-rmpc.ron" "${config.xdg.configHome}/rmpc/themes/custom-rmpc.ron"
    ln -sf "${config.xdg.cacheHome}/wal/custom-btop.theme" "${config.xdg.configHome}/btop/themes/pywal.theme"
    ln -sf "${config.xdg.cacheHome}/wal/custom-k9s.yaml" "${config.xdg.configHome}/k9s/skins/pywal.yaml"

    mkdir -p "${config.xdg.configHome}/Kvantum"
    mkdir -p "${config.xdg.cacheHome}/wal/Plasma"
    mkdir -p "${config.xdg.cacheHome}/wal/Plasma/Pywal"
    ln -sf "${config.xdg.cacheHome}/wal/Plasma/Pywal" "${config.xdg.configHome}/Kvantum/Pywal"
    mkdir -p "${config.xdg.cacheHome}/wal/Plasma/PywalNT"
    ln -sf "${config.xdg.cacheHome}/wal/Plasma/PywalNT" "${config.xdg.configHome}/Kvantum/PywalNT"
    mkdir -p "${config.xdg.dataHome}/color-schemes"
    ln -sf "${config.xdg.cacheHome}/wal/Plasma/color-scheme.colors" "${config.xdg.dataHome}/color-schemes/Pywal.colors"
    kvantum_file="${config.xdg.configHome}/Kvantum/kvantum.kvconfig"
    if [ ! -f "$kvantum_file" ]; then
      echo -e "[General]\ntheme=Pywal\n\n[Applications]\nPywalNT=gwenview, systemsettings, partitionmanager" > "$kvantum_file"
    fi

    if [ ! -x "$HOME/.local/bin/wal-telegram" ]; then
      /usr/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/colors.wt-constants > "$HOME/.local/bin/colors.wt-constants"
      /usr/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/wal-telegram > "$HOME/.local/bin/wal-telegram"
      chmod +x "$HOME/.local/bin/wal-telegram"
      # Dont forget to set in telegram app to ~/.cache/wal/wal.tdesktop-theme
    fi

    if [ ! -d "$HOME/.build/cursors" ]; then
      /usr/bin/git clone https://github.com/mshnwq/cursors $HOME/.build/cursors
    fi
    mkdir -p "$HOME/.build/cursors/dist"
    mkdir -p "${config.xdg.dataHome}/icons"
    ln -sf "$HOME/.build/cursors/dist/catppuccin-mocha-pywal-cursors" \
        "${config.xdg.dataHome}/icons/catppuccin-mocha-pywal-cursors"
    mkdir -p "${config.xdg.cacheHome}/wal/cursors"

    if [ ! -d "$HOME/.build/qbittorrent" ]; then
      /usr/bin/git clone https://github.com/catppuccin/qbittorrent $HOME/.build/qbittorrent
      sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' $HOME/.build/qbittorrent/tools/build
      echo 'rcc src/catppuccin-pywal/resources.qrc -o dist/catppuccin-pywal.qbtheme -binary' >> $HOME/.build/qbittorrent/tools/build
    fi
    mkdir -p "${config.xdg.cacheHome}/wal/qbit"
    mkdir -p "${config.xdg.cacheHome}/wal/qbit/icons"
    mkdir -p "${config.xdg.cacheHome}/wal/qbit/icons/pwal"
    mkdir -p "${config.xdg.cacheHome}/wal/qbit/catppuccin-pywal"
    ln -sf "${config.xdg.cacheHome}/wal/qbit/catppuccin-pywal" \
      "$HOME/.build/qbittorrent/src/catppuccin-pywal"
    ln -sf "${config.xdg.cacheHome}/wal/qbit/icons/pywal" \
      "$HOME/.build/qbittorrent/src/icons/pywal"

    if [ ! -d "$HOME/.build/shyfox" ]; then
      /usr/bin/git clone https://github.com/mshnwq/shyfox $HOME/.build/shyfox
      ln -sf "$HOME/.build/shyfox/ShyFox" \
          "$HOME/.mozilla/firefox/mshnwq.default/chrome/ShyFox"
      ln -sf "$HOME/.build/shyfox/icons" \
          "$HOME/.mozilla/firefox/mshnwq.default/chrome/icons"
    fi

    #if [ ! -d "$HOME/.local/share/icons/Papirus" ]; then
      # TODO: /usr/bin/curl -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
    #fi
  '';

  # TODO:
  # Gnome Apps # https://github.com/catppuccin/gtk
  # Veracrypt    (nix)
  # Virt-Manager (nix)
  # DistroShelf  (flatpak)
  # FlatSeal     (flatpak)
  # Warehouse    (flatpak)
  # Other:
  # Obsidian  (nix)      # https://github.com/Schweem/Pywal-Obsidian
}
# https://nix.catppuccin.com/getting-started/flakes/
