# # programs/anki.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfgDir = "${config.xdg.dataHome}/Anki2";
  addonsDir = "${cfgDir}/addons21";
  theme = "followSystem";
  style = "native";
  minimalistMode = true;

  # https://tatsumoto.neocities.org/blog/setting-up-anki
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/anki/helper.nix
  # Define addons with metadata
  addons = [
    # TODO: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/an/anki/addons/review-heatmap/default.nix#L54
    {
      id = "2055492159";
      src = pkgs.fetchFromSourcehut {
        owner = "~foosoft";
        repo = "anki-connect";
        tag = "25.11.9.0";
        hash = "sha256-cnAH4qIuxSJIM7vmSDU+eppnRi6Out9oSWHBHKCGLZI=";
      };
      sourcedir = "plugin";
      extraRun = "";
    }
    {
      id = "688199788";
      src = pkgs.fetchFromGitHub {
        owner = "AnKing-VIP";
        repo = "AnkiRecolor";
        rev = "12e42fc";
        hash = "sha256-TbDUVCfqDXQmCwRgDW+hLZPfIElQAW2wFFgWOc3iKiU=";
        sparseCheckout = [ "src/addon" ];
      };
      sourcedir = "src/addon";
      extraRun = ''
        rm -rf "$ADDON_DEST/AnKing"
        ln -sf "$HOME/.cache/wal/custom-anki.json" \
          "$ADDON_DEST/config.json"
        ln -sf "$HOME/.cache/wal/custom-anki.json" \
          "$ADDON_DEST/meta.json"
        ln -s "$HOME/.cache/wal/custom-anki.json" \
          "$ADDON_DEST/themes/(dark) Pywal.json"
      '';
    }
    {
      id = "1210908941";
      src = pkgs.fetchFromGitHub {
        owner = "AnKing-VIP";
        repo = "Custom-background-image-and-gear-icon";
        rev = "9706a8f";
        hash = "sha256-v9/WR+3DK9+byudHFAtsCsPW3WmRVY003+ufEqIFIxM=";
        sparseCheckout = [ "addon" ];
      };
      sourcedir = "addon";
      extraRun = ''
        USER_FILES="$ADDON_DEST/user_files"
        # Remove AnKing folder
        rm -rf "$ADDON_DEST/AnKing"
        # Copy default_gear to gear
        if [ -d "$USER_FILES/default_gear" ]; then
          cp -r "$USER_FILES/default_gear" "$USER_FILES/gear"
        fi
        # Remove default_background and background directories
        rm -rf "$USER_FILES/default_background"
        rm -rf "$USER_FILES/background"
        # Create symlink to rice wallpapers
        ln -sf "$HOME/.cache/wal/custom-anki-bg.json" "$ADDON_DEST/config.json"
        RICE_FILE="$HOME/.config/dots/.rice"
        if [ -f "$RICE_FILE" ]; then
          RICE=$(cat "$RICE_FILE")
          WALLS_DIR="$HOME/.config/dots/rices/$RICE/walls"
          if [ -d "$WALLS_DIR" ]; then
            ln -sf "$WALLS_DIR" "$USER_FILES/background"
            ln -sf "$WALLS_DIR" "$USER_FILES/default_background"
            echo "  Linked background to $WALLS_DIR"
          else
            echo "  Warning: Wallpapers directory not found: $WALLS_DIR"
          fi
        else
          echo "  Warning: Rice config file not found: $RICE_FILE"
        fi
      '';
    }
  ];

  installAddons = pkgs.writeShellScript "install-anki-addons" ''
    ADDONS_DIR="${addonsDir}"
    mkdir -p "$ADDONS_DIR"
    ${lib.concatMapStringsSep "\n" (addon: ''
      ADDON_SRC="${addon.src}/${addon.sourcedir}"
      ADDON_DEST="$ADDONS_DIR/${addon.id}"
      if [ -d "$ADDON_SRC" ]; then
        rm -rf "$ADDON_DEST"
        cp -r "$ADDON_SRC" "$ADDON_DEST"
        chmod -R u+w "$ADDON_DEST"
        echo "Installed ${addon.id} to $ADDON_DEST"
        ${addon.extraRun}
      else
        echo "Warning: Source directory not found for ${addon.id}"
      fi
    '') addons}
  '';
in
{
  home.packages = with pkgs; [
    anki
  ];

  home.activation.installAnkiAddons =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        $DRY_RUN_CMD ${installAddons}
      '';
}
