# pkgs/guitarpro.nix
{
  wine,
  fetchurl,
  makeDesktopItem,
  makeDesktopIcon,
  copyDesktopItems,
  copyDesktopIcons,
  mkWindowsAppNoCC,
}:
mkWindowsAppNoCC rec {
  inherit wine;

  pname = "guitarpro";
  version = "8.0";

  wineArch = "win64";
  dontUnpack = true;
  nativeBuildInputs = [
    copyDesktopItems
    copyDesktopIcons
  ];
  fileMapDuringAppInstall = true;

  src = fetchurl {
    url = "https://download-fr-3.guitar-pro.com/gp8/stable/guitar-pro-8-setup.exe";
    hash = "sha256-CrP1oBN9vF5OL3v1ByzBW3wkvGEY+VTGF4dNApWgR1o=";
  };

  fileMap = {
    "$HOME/.local/share/guitar-pro-8" =
      "drive_c/users/$USER/AppData/Roaming/Arobas Music/Guitar Pro 8";
  };

  winAppInstall = ''
    echo "Preparing Wineprefix..."
    WINEARCH=${wineArch} WINEPREFIX="$WINEPREFIX" winetricks -q win7
    WINEARCH=${wineArch} WINEPREFIX="$WINEPREFIX" winetricks -q corefonts
    echo "Installing Guitar Pro 8..."
    $WINE start /unix ${src}
  '';

  winAppRun = ''
    $WINE start /unix "$WINEPREFIX/drive_c/Program Files/Arobas Music/Guitar Pro 8/GuitarPro.exe" "$ARGS"
  '';

  installPhase = ''
    runHook preInstall
    cp $out/bin/.launcher $out/bin/.guitar-pro-8-launcher
    rm $out/bin/.launcher
    ln -s $out/bin/.guitar-pro-8-launcher $out/bin/${pname}
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = ''env DISPLAY="" ${pname}'';
      icon = pname;
      desktopName = pname;
      categories = [
        "Music"
      ];
      mimeTypes = builtins.map (s: "application/" + s) [
        "gpx"
        "x-gpx"
        "x-gpt"
        "x-guitar-pro"
        "x-guitarpro"
        "x-gnuplot"
      ];
    })
  ];

  desktopIcon = makeDesktopIcon {
    name = pname;
    icoIndex = 0;
    src = ./guitarpro.png;
  };
}
