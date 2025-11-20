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

  builddirRaw = builtins.readFile "${cfg}/builddir";
  builddir =
    builtins.replaceStrings [ "~" ] [ config.home.homeDirectory ]
      builddirRaw;

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
      kdePackages.qtstyleplugin-kvantum
      papirus-folders # cli tool
    ]
    ++ [
      pkgs-stable.highlight
      pkgs-stable.pywal16
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
        BUILDDIR=${builddir}

        mkdir -p "$HOME/Documents/GP8"

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

        if [ ! -d "$BUILDDIR/cursors" ]; then
          ${pkgs.git}/bin/git clone https://github.com/mshnwq/cursors $BUILDDIR/cursors
        fi
        mkdir -p "$BUILDDIR/cursors/dist"
        mkdir -p "${data}/icons"
        ln -sf "$BUILDDIR/cursors/dist/catppuccin-mocha-pywal-cursors" \
            "${config.xdg.dataHome}/icons/catppuccin-mocha-pywal-cursors"
        mkdir -p "${cache}/wal/cursors"

        if [ ! -d "$BUILDDIR/qbittorrent" ]; then
          ${pkgs.git}/bin/git clone https://github.com/catppuccin/qbittorrent $BUILDDIR/qbittorrent
          sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' $BUILDDIR/qbittorrent/tools/build
          echo 'rcc src/catppuccin-pywal/resources.qrc -o dist/catppuccin-pywal.qbtheme -binary' >> $BUILDDIR/qbittorrent/tools/build
        fi
        mkdir -p "${cache}/wal/qbit"/{icons/pywal,catppuccin-pywal}
        ln -sf "${cache}/wal/qbit/catppuccin-pywal" \
          "$BUILDDIR/qbittorrent/src/catppuccin-pywal"
        ln -sf "${cache}/wal/qbit/icons/pywal" \
          "$BUILDDIR/qbittorrent/src/icons/pywal"

        ICONS_DIR="$HOME/.local/share/icons"
        if [ ! -d "$ICONS_DIR/Papirus" ]; then
          ICONS_VERSION="20250501"
          mkdir -p "$ICONS_DIR"
          tmp=$(mktemp --suffix=.zip)
          trap "rm -f '$tmp'" EXIT
          ${pkgs.curl}/bin/curl -L --fail -o "$tmp" \
            https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/$ICONS_VERSION.zip
          ${pkgs.unzip}/bin/unzip "$tmp" -d "$ICONS_DIR"
          ZIPROOT="papirus-icon-theme-$ICONS_VERSION"
          mv "$ICONS_DIR/$ZIPROOT/Papirus" "$ICONS_DIR/"
          mv "$ICONS_DIR/$ZIPROOT/Papirus-Dark" "$ICONS_DIR/"
          mv "$ICONS_DIR/$ZIPROOT/Papirus-Light" "$ICONS_DIR/"
          rm -rf "$ICONS_DIR/$ZIPROOT"
        fi
      '';
  # TODO: broken Gnome apps theme
  # Veracrypt    (nix)
  # Virt-Manager (flatpak)
  # DistroShelf  (flatpak)
  # FlatSeal     (flatpak)
  # Warehouse    (flatpak)
}
# https://nix.catppuccin.com/getting-started/flakes/
