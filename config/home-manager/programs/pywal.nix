# programs/pywal.nix
{
  pkgs,
  config,
  inputs,
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
    "cava/config" = "${walCache}/custom-cava";
    "dunst/dunstrc" = "${walCache}/custom-dunstrc";
    "yazi/theme.toml" = "${walCache}/custom-yazi.toml";
    "tmux/pywal.conf" = "${walCache}/custom-tmux.conf";
    "zathura/zathurarc" = "${walCache}/colors-zathura";
    "rofi/shared.rasi" = "${walCache}/custom-rofi.rasi";
    "aerc/stylesets/default" = "${walCache}/custom-aerc";
    "k9s/skins/pywal.yaml" = "${walCache}/custom-k9s.yaml";
    "mpv/themes/pywal.conf" = "${walCache}/custom-mpv.conf";
    "rmpc/themes/pywal.ron" = "${walCache}/custom-rmpc.ron";
    "btop/themes/pywal.theme" = "${walCache}/custom-btop.theme";
    "kitty/custom-kitty.conf" = "${walCache}/custom-kitty.conf";
    "waybar/colors-waybar.css" = "${walCache}/colors-waybar.css";
    "alacritty/colors-alacritty.toml" = "${walCache}/colors-alacritty.toml";
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
      qimgv
      vips
      papirus-folders # cli tool
      pywalfox-native # do pywalfox install
      kdePackages.qtstyleplugin-kvantum
    ]
    ++ [
      pkgs-stable.pywal16
      pkgs-stable.highlight
    ]
    ++ (with pkgs.nerd-fonts; [
      fira-code
      fira-mono
      roboto-mono
      inconsolata
      symbols-only
      jetbrains-mono
    ]);

  home.file."${config.xdg.configHome}/qimgv/qimgv.conf" = {
    force = true;
    text = ''
      [General]
      imageScrolling=1
      defaultFitMode=0
      folderEndAction=0
      defaultViewMode=0
      expandImage=false
      confirmTrash=true
      confirmDelete=true
      blurBackground=true
      clickableEdges=true
      backgroundOpacity=0
      defaultCropAction=0
      cursorAutohiding=true
      autoResizeWindow=false
      focusPointIn1to1Mode=1
      folderViewIconSize=120
      enableSmoothScroll=true
      drawTransparencyGrid=false
      clickableEdgesVisible=false

      [Controls]
      shortcuts="zoomIn=+", "frameStepBack=,", "zoomOut=-", "frameStep=.", "fitWindow=1", "fitWidth=2", "fitNormal=3", "zoomIn=eq", "exit=Alt+X", "folderView=Backspace", "copyFile=C", "zoomIn=Ctrl++", "zoomOut=Ctrl+-", "zoomIn=Ctrl+eq", "copyFileClipboard=Ctrl+C", "showInDirectory=Ctrl+D", "zoomOut=Ctrl+Down", "rotateLeft=Ctrl+L", "seekVideoBackward=Ctrl+Left", "open=Ctrl+O", "print=Ctrl+P", "rotateRight=Ctrl+R", "seekVideoForward=Ctrl+Right", "save=Ctrl+S", "copyPathClipboard=Ctrl+Shift+C", "saveAs=Ctrl+Shift+S", "zoomIn=Ctrl+Up", "pasteFile=Ctrl+V", "setWallpaper=Ctrl+W", "zoomOutCursor=Ctrl+WheelDown", "zoomInCursor=Ctrl+WheelUp", "discardEdits=Ctrl+Z", "toggleShuffle=Ctrl+`", "moveToTrash=Del", "zoomOutCursor=Down", "jumpToLast=End", "folderView=Enter", "closeFullScreenOrExit=Esc", "toggleFullscreen=F", "toggleFullscreen=F11", "renameFile=F2", "reloadImage=F5", "flipH=H", "jumpToFirst=Home", "toggleImageInfo=I", "toggleFullscreen=LMB_DoubleClick", "prevImage=Left", "moveFile=M", "contextMenu=Menu", "exit=MiddleButton", "openSettings=P", "exit=Q", "resize=R", "contextMenu=RMB", "nextImage=Right", "removeFile=Shift+Del", "toggleFullscreenInfoBar=Shift+F", "prevDirectory=Shift+Left", "nextDirectory=Shift+Right", "toggleFitMode=Space", "zoomInCursor=Up", "flipV=V", "nextImage=WheelDown", "prevImage=WheelUp", "crop=X", "prevImage=XButton1", "nextImage=XButton2", "toggleSlideshow=`"

      [Scripts]
      script\size=0
    '';
  };

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
          echo -e "[General]\ntheme=Pywal\n\n[Applications]\nPywalNT=gwenview, systemsettings" > "$kvantum_file"
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

        mkdir -p "${cfg}/keepassxc"
        keepass_file="${cfg}/keepassxc/keepassxc.ini"
        if [ ! -f "$keepass_file" ]; then
          cat > "$keepass_file" <<EOF
        [General]
        ConfigVersion=2

        [Browser]
        CustomProxyLocation=
        Enabled=true

        [GUI]
        TrayIconAppearance=monochrome-light
        ApplicationTheme=classic

        [PasswordGenerator]
        AdditionalChars=
        ExcludedChars=
        EOF
        fi

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
