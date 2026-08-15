# programs/pywal.nix
{
  pkgs,
  config,
  inputs,
  ...
}:
let
  entryAfter = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ];

  share = config.xdg.dataHome;
  state = config.xdg.stateHome;
  cfg = config.xdg.configHome;
  cache = config.xdg.cacheHome;
  home = config.home.homeDirectory;

  # ~/.config/builddir lets the user point big theme-build clones (cursors,
  # qbittorrent) somewhere other than the default, e.g. a tmpfs. Fall back to
  # a sane default so the flake still evaluates on a machine that hasn't
  # created the file yet.
  builddirFile = "${cfg}/builddir";
  builddir =
    if builtins.pathExists builddirFile then
      builtins.replaceStrings [ "~" ] [ home ] (builtins.readFile builddirFile)
    else
      "${home}/Documents/.build";

  walCache = "${cache}/wal";
  walLinks = {
    "cava/config" = "${walCache}/custom-cava";
    "dunst/dunstrc" = "${walCache}/custom-dunstrc";
    "gtt/theme.yaml" = "${walCache}/custom-gtt.yaml";
    "yazi/theme.toml" = "${walCache}/custom-yazi.toml";
    "tmux/pywal.conf" = "${walCache}/custom-tmux.conf";
    "glow/pywal.json" = "${walCache}/custom-glow.json";
    "zathura/zathurarc" = "${walCache}/colors-zathura"; # Ctrl+r toggle recolor
    "rofi/shared.rasi" = "${walCache}/custom-rofi.rasi";
    "aerc/stylesets/default" = "${walCache}/custom-aerc";
    "k9s/skins/pywal.yaml" = "${walCache}/custom-k9s.yaml";
    "mpv/themes/pywal.conf" = "${walCache}/custom-mpv.conf";
    "rmpc/themes/pywal.ron" = "${walCache}/custom-rmpc.ron";
    "btop/themes/pywal.theme" = "${walCache}/custom-btop.theme";
    "kitty/custom-kitty.conf" = "${walCache}/custom-kitty.conf";
    "hypr/configs/pywal.lua" = "${walCache}/custom-hyprland.lua";
    "waybar/colors-waybar.css" = "${walCache}/colors-waybar.css";
    "alacritty/colors-alacritty.toml" = "${walCache}/colors-alacritty.toml";
  };

  # Shared by the cursor/qbittorrent setup scripts below.
  cloneIfMissingFn = ''
    clone_if_missing() {
      local url="$1" dest="$2"
      if [ ! -d "$dest" ]; then
        ${pkgs.git}/bin/git clone "$url" "$dest"
      fi
    }
  '';

  linkWalTheme = pkgs.writeShellScript "pywal-link-theme" ''
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

    mkdir -p "$HOME/Documents/GP8"
  '';

  setupKvantumTheme = pkgs.writeShellScript "pywal-setup-kvantum" ''
    mkdir -p "${cfg}/Kvantum"
    mkdir -p "${cache}/wal/Plasma"/{Pywal,PywalNT}
    ln -sf "${cache}/wal/Plasma/Pywal" "${cfg}/Kvantum/Pywal"
    ln -sf "${cache}/wal/Plasma/PywalNT" "${cfg}/Kvantum/PywalNT"

    mkdir -p "${share}/color-schemes"
    ln -sf "${cache}/wal/Plasma/color-scheme.colors" "${share}/color-schemes/Pywal.colors"

    kvantum_file="${cfg}/Kvantum/kvantum.kvconfig"
    if [ ! -f "$kvantum_file" ]; then
      echo -e "[General]\ntheme=Pywal\n\n[Applications]\nPywalNT=gwenview, systemsettings" > "$kvantum_file"
    fi
  '';

  fetchWalTelegram = pkgs.writeShellScript "pywal-fetch-wal-telegram" ''
    if [ ! -x "$HOME/.local/bin/wal-telegram" ]; then
      ${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/colors.wt-constants > "$HOME/.local/bin/colors.wt-constants"
      ${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/guillaumeboehm/wal-telegram/refs/heads/master/wal-telegram > "$HOME/.local/bin/wal-telegram"
      chmod +x "$HOME/.local/bin/wal-telegram"
      # Dont forget to set in telegram app to ~/.cache/wal/wal.tdesktop-theme
    fi
  '';

  setupCursorTheme = pkgs.writeShellScript "pywal-setup-cursors" ''
    ${cloneIfMissingFn}
    BUILDDIR=${builddir}

    clone_if_missing https://github.com/mshnwq/cursors "$BUILDDIR/cursors"
    mkdir -p "$BUILDDIR/cursors/dist"
    mkdir -p "${share}/icons"
    ln -sf "$BUILDDIR/cursors/dist/catppuccin-mocha-pywal-cursors" \
        "${share}/icons/catppuccin-mocha-pywal-cursors"
    mkdir -p "${cache}/wal/cursors"
  '';

  setupKeepassxcConfig = pkgs.writeShellScript "pywal-setup-keepassxc" ''
    mkdir -p "${cfg}/keepassxc"
    keepass_file="${cfg}/keepassxc/keepassxc.ini"
    if [ ! -f "$keepass_file" ]; then
      cat > "$keepass_file" <<'EOF'
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
  '';

  setupQbittorrentTheme = pkgs.writeShellScript "pywal-setup-qbittorrent" ''
    ${cloneIfMissingFn}
    BUILDDIR=${builddir}

    if [ ! -d "$BUILDDIR/qbittorrent" ]; then
      clone_if_missing https://github.com/catppuccin/qbittorrent "$BUILDDIR/qbittorrent"
      sed -i -e :a -e '$d;N;2,3ba' -e 'P;D' "$BUILDDIR/qbittorrent/tools/build"
      echo 'rcc src/catppuccin-pywal/resources.qrc -o dist/catppuccin-pywal.qbtheme -binary' >> "$BUILDDIR/qbittorrent/tools/build"
    fi
    mkdir -p "${cache}/wal/qbit"/{icons/pywal,catppuccin-pywal}
    ln -sf "${cache}/wal/qbit/catppuccin-pywal" \
      "$BUILDDIR/qbittorrent/src/catppuccin-pywal"
    ln -sf "${cache}/wal/qbit/icons/pywal" \
      "$BUILDDIR/qbittorrent/src/icons/pywal"
  '';

  linkFonts = pkgs.writeShellScript "pywal-link-fonts" ''
    FONTS_DIR="$HOME/.local/share/fonts"
    if [ ! -d "$FONTS_DIR" ]; then
      ln -sf "${state}/nix/profile/share/fonts" "$FONTS_DIR"
    fi
  '';

  installPapirusIcons = pkgs.writeShellScript "pywal-install-papirus-icons" ''
    ICONS_DIR="$HOME/.local/share/icons"
    if [ ! -d "$ICONS_DIR/Papirus" ]; then
      ICONS_VERSION="20250501"
      mkdir -p "$ICONS_DIR"
      tmp=$(mktemp --suffix=.zip)
      ${pkgs.curl}/bin/curl -L --fail -o "$tmp" \
        https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/$ICONS_VERSION.zip
      ${pkgs.unzip}/bin/unzip "$tmp" -d "$ICONS_DIR"
      rm -f "$tmp"
      ZIPROOT="papirus-icon-theme-$ICONS_VERSION"
      mv "$ICONS_DIR/$ZIPROOT/Papirus" "$ICONS_DIR/"
      mv "$ICONS_DIR/$ZIPROOT/Papirus-Dark" "$ICONS_DIR/"
      mv "$ICONS_DIR/$ZIPROOT/Papirus-Light" "$ICONS_DIR/"
      rm -rf "$ICONS_DIR/$ZIPROOT"
    fi
  '';
in
{
  home.packages =
    with pkgs;
    [
      vips
      qimgv
      pywal16
      papirus-folders # cli tool
      highlight
      kdePackages.qtstyleplugin-kvantum
      noto-fonts # has the ancient texts
    ]
    ++ (with pkgs.nerd-fonts; [
      noto
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
      autoResizeWindow=false
      backgroundOpacity=0
      blurBackground=true
      clickableEdges=false
      clickableEdgesVisible=false
      confirmDelete=true
      confirmTrash=true
      cursorAutohiding=true
      defaultCropAction=0
      defaultFitMode=0
      defaultViewMode=0
      drawTransparencyGrid=false
      enableSmoothScroll=true
      expandImage=false
      focusPointIn1to1Mode=1
      folderEndAction=0
      folderViewIconSize=120
      imageScrolling=0

      [Controls]
      shortcuts="zoomIn=+", "frameStepBack=,", "zoomOut=-", "frameStep=.", "fitWindow=1", "fitWidth=2", "fitNormal=3", "zoomIn=eq", "exit=Alt+X", "folderView=Backspace", "copyFile=C", "zoomIn=Ctrl++", "zoomOut=Ctrl+-", "zoomIn=Ctrl+eq", "copyFileClipboard=Ctrl+C", "showInDirectory=Ctrl+D", "zoomOut=Ctrl+Down", "rotateLeft=Ctrl+L", "seekVideoBackward=Ctrl+Left", "open=Ctrl+O", "print=Ctrl+P", "rotateRight=Ctrl+R", "seekVideoForward=Ctrl+Right", "save=Ctrl+S", "copyPathClipboard=Ctrl+Shift+C", "saveAs=Ctrl+Shift+S", "zoomIn=Ctrl+Up", "pasteFile=Ctrl+V", "setWallpaper=Ctrl+W", "zoomOutCursor=Ctrl+WheelDown", "zoomInCursor=Ctrl+WheelUp", "discardEdits=Ctrl+Z", "toggleShuffle=Ctrl+`", "moveToTrash=Del", "zoomOutCursor=Down", "jumpToLast=End", "folderView=Enter", "closeFullScreenOrExit=Esc", "toggleFullscreen=F", "toggleFullscreen=F11", "renameFile=F2", "reloadImage=F5", "flipH=H", "jumpToFirst=Home", "toggleImageInfo=I", "toggleFullscreen=LMB_DoubleClick", "prevImage=Left", "moveFile=M", "contextMenu=Menu", "exit=MiddleButton", "openSettings=P", "exit=Q", "resize=R", "contextMenu=RMB", "nextImage=Right", "removeFile=Shift+Del", "toggleFullscreenInfoBar=Shift+F", "prevDirectory=Shift+Left", "nextDirectory=Shift+Right", "toggleFitMode=Space", "zoomInCursor=Up", "flipV=V", "nextImage=WheelDown", "prevImage=WheelUp", "crop=X", "prevImage=XButton1", "nextImage=XButton2", "toggleSlideshow=`"

      [Scripts]
      script\size=0
    '';
  };

  # https://github.com/charmbracelet/glamour/blob/master/styles/gallery/README.md
  home.file."${config.xdg.configHome}/glow/glow.yml" = {
    force = true;
    text = ''
      style: "${config.xdg.configHome}/glow/pywal.json"
      width: 80
    '';
  };

  home.activation = {
    linkWalTheme = entryAfter "$DRY_RUN_CMD ${linkWalTheme}";
    setupKvantumTheme = entryAfter "$DRY_RUN_CMD ${setupKvantumTheme}";
    fetchWalTelegram = entryAfter "$DRY_RUN_CMD ${fetchWalTelegram}";
    setupCursorTheme = entryAfter "$DRY_RUN_CMD ${setupCursorTheme}";
    setupKeepassxcConfig = entryAfter "$DRY_RUN_CMD ${setupKeepassxcConfig}";
    setupQbittorrentTheme = entryAfter "$DRY_RUN_CMD ${setupQbittorrentTheme}";
    installPapirusIcons = entryAfter "$DRY_RUN_CMD ${installPapirusIcons}";
    linkFonts = entryAfter "$DRY_RUN_CMD ${linkFonts}";
  };
}
# https://nix.catppuccin.com/getting-started/flakes/
