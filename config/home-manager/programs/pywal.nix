# programs/pywal.nix
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  data = config.xdg.dataHome;
  cfg = config.xdg.configHome;
  cache = config.xdg.cacheHome;

  walCache = "${cache}/wal";
  walLinks = {
    "yazi/theme.toml" = "${walCache}/custom-yazi.toml";
    "kitty/custom-kitty.conf" = "${walCache}/custom-kitty.conf";
    "tmux/pywal.conf" = "${walCache}/custom-tmux.conf";
    "zathura/zathurarc" = "${walCache}/colors-zathura";
    "waybar/colors-waybar.css" = "${walCache}/colors-waybar.css";
    "alacritty/colors-alacritty.toml" = "${walCache}/colors-alacritty.toml";
    "dunst/dunstrc" = "${walCache}/custom-dunstrc";
    "cava/config" = "${walCache}/custom-cava";
    "rofi/shared.rasi" = "${walCache}/custom-rofi.rasi";
    "rmpc/themes/custom-rmpc.ron" = "${walCache}/custom-rmpc.ron";
    "btop/themes/pywal.theme" = "${walCache}/custom-btop.theme";
    "k9s/skins/pywal.yaml" = "${walCache}/custom-k9s.yaml";
  };

  system = pkgs.system;
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
  };
in
{
  home.packages =
    with pkgs;
    [
      pywalfox-native # do pywalfox install
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
    ]
    ++ [
      pkgs-stable.highlight
      pkgs-stable.pywal16 # SOLUTION
    ]
    ++ (with pkgs.nerd-fonts; [
      jetbrains-mono
      roboto-mono
      fira-mono
      fira-code
      inconsolata
      symbols-only
    ]);

  home.activation.linkWalTheme =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        ${builtins.concatStringsSep "\n" (
          builtins.map (
            target:
            let
              dir = builtins.dirOf "${cfg}/${target}";
            in
            ''
              mkdir -p "${dir}"
              ln -sf "${walLinks.${target}}" "${cfg}/${target}"
            ''
          ) (builtins.attrNames walLinks)
        )}

        mkdir -p "${cfg}/Kvantum"
        mkdir -p "${cache}/wal/Plasma"/{Pywal,PywalNT}
        ln -sf "${cache}/wal/Plasma/Pywal" "${cfg}/Kvantum/Pywal"
        ln -sf "${cache}/wal/Plasma/PywalNT" "${cfg}/Kvantum/PywalNT"

        mkdir -p "${data}/color-schemes"
        ln -sf "${cache}/wal/Plasma/color-scheme.colors" "${data}/color-schemes/Pywal.colors"
        kvantum_file="${cfg}/Kvantum/kvantum.kvconfig"
        if [ ! -f "$kvantum_file" ]; then
          echo -e "[General]\ntheme=Pywal\n\n[Applications]\nPywalNT=gwenview, systemsettings, partitionmanager" > "$kvantum_file"
        fi

        if [ ! -x "$HOME/.local/bin/wal-telegram" ]; then
          ${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/colors.wt-constants > "$HOME/.local/bin/colors.wt-constants"
          ${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/wal-telegram > "$HOME/.local/bin/wal-telegram"
          chmod +x "$HOME/.local/bin/wal-telegram"
          # Dont forget to set in telegram app to ~/.cache/wal/wal.tdesktop-theme
        fi

        if [ ! -d "$HOME/.build/cursors" ]; then
          ${pkgs.git}/bin/git clone https://github.com/mshnwq/cursors $HOME/.build/cursors
        fi
        mkdir -p "$HOME/.build/cursors/dist"
        mkdir -p "${data}/icons"
        ln -sf "$HOME/.build/cursors/dist/catppuccin-mocha-pywal-cursors" \
            "${config.xdg.dataHome}/icons/catppuccin-mocha-pywal-cursors"
        mkdir -p "${cache}/wal/cursors"

        if [ ! -d "$HOME/.build/qbittorrent" ]; then
          ${pkgs.git}/bin/git clone https://github.com/catppuccin/qbittorrent $HOME/.build/qbittorrent
          sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' $HOME/.build/qbittorrent/tools/build
          echo 'rcc src/catppuccin-pywal/resources.qrc -o dist/catppuccin-pywal.qbtheme -binary' >> $HOME/.build/qbittorrent/tools/build
        fi
        mkdir -p "${cache}/wal/qbit"/{icons/pwal,catppuccin-pywal}
        ln -sf "${cache}/wal/qbit/catppuccin-pywal" \
          "$HOME/.build/qbittorrent/src/catppuccin-pywal"
        ln -sf "${cache}/wal/qbit/icons/pywal" \
          "$HOME/.build/qbittorrent/src/icons/pywal"

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
}
# https://nix.catppuccin.com/getting-started/flakes/
