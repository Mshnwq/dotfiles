# programs/anki.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  profileName = config.home.username;
  cfgDir = "${config.xdg.dataHome}/Anki2";
  # https://tatsumoto.neocities.org/blog/setting-up-anki
  deckDir = "${config.home.homeDirectory}/Documents/Anki/";
  # NOTE: if first time, get file in link, manually import, then export with legacy option to work
  # https://github.com/alyssabedard/mpv2anki/blob/master/docs/note_types/basic/Sentence%20Mining.apkg

  addons = [
    # https://github.com/glutanimate/review-heatmap
    {
      id = "1771074083";
      src = pkgs.ankiAddons.review-heatmap;
      sourcedir = "share/anki/addons/review-heatmap";
      extraRun = ''
        sed -i '484a /* end */' "$ADDON_DEST/web/anki-review-heatmap.js"
      '';
    }

    # https://github.com/lambdadog/passfail2
    {
      id = "876946123";
      src = pkgs.fetchFromGitHub {
        owner = "lambdadog";
        repo = "passfail2";
        rev = "d5313e4f1217e968b36edbc0a4fe92386209ffe6";
        hash = "sha256-HMe6/fHpYj/MN0dUFj3W71vK7qqcp9l1xm8SAiKkJLs=";
      };
      sourcedir = "";
      extraRun = ''
        IN="$ADDON_DEST/build_info.py.in"
        OUT="''${IN%.in}"
        sed 's/\$version/"0.3.0"/' "$IN" > "$OUT"
      '';
    }

    # https://git.sr.ht/~foosoft/anki-connect
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

    # https://github.com/AnKing-VIP/AnkiRecolor
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

    # https://github.com/AnKing-VIP/Custom-background-image-and-gear-icon
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
    ADDONS_DIR="${cfgDir}/addons21"
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

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/anki/helper.nix
  # https://devotd.wordpress.com/2021/02/10/anki-decks-in-python-import-export/
  initAnkiConfig = pkgs.writeShellScript "init-anki-config" ''
    if [ ! -f "${cfgDir}/prefs21.db" ]; then
      mkdir -p "${cfgDir}"
      echo "sh: Initializing Anki configuration..."
      export PYTHONPATH="${pkgs.anki.lib}/lib/python3.13/site-packages:$PYTHONPATH"
      ${pkgs.python3}/bin/python3 <<'EOF'
    import os, sys, glob
    from aqt.profiles import ProfileManager
    from aqt.theme import Theme, WidgetStyle, theme_manager
    from anki.collection import Collection
    from anki.importing.apkg import AnkiPackageImporter
    profile_manager = ProfileManager(
      ProfileManager.get_created_base_folder("${cfgDir}")
    )
    _ = profile_manager.setupMeta()
    profile_manager.meta["firstRun"] = False
    profile_manager.setLang("en_US")
    widget_style: WidgetStyle = WidgetStyle.NATIVE
    theme_manager.apply_style = lambda: None
    profile_manager.set_widget_style(widget_style)
    profile_manager.set_minimalist_mode(True)
    profile_manager.set_answer_key(1, "h") # Again (Fail)
    profile_manager.set_answer_key(3, "j") # Good  (Pass)
    # profile_manager.set_answer_key(2, "2") # Hard  (Fail)
    # profile_manager.set_answer_key(4, "4") # Easy  (Pass)
    profile_manager.create("${profileName}")
    profile_manager.openProfile("${profileName}")
    profile_manager.profile["lastOptimize"] = None
    profile_manager.save()
    col_path = profile_manager.collectionPath()
    col = Collection(col_path)
    col.decks.add_normal_deck_with_name("Learning")
    deck_dir = "${deckDir}"
    if os.path.exists(deck_dir):
      apkg_files = glob.glob(os.path.join(deck_dir, "*.apkg"))
      for deck_path in apkg_files:
        importer = AnkiPackageImporter(col, deck_path)
        importer.run()
    col.close()
    print("py: Configuration ${profileName} saved successfully")
    EOF
      chmod -R u+w "${cfgDir}"
      echo "sh: Anki configuration initialized"
    fi
  '';

  closeAnkiUpdateDialog = pkgs.writeShellScript "close-anki-update-dialog" ''
    sleep 5
    for i in {1..50}; do
      # Check if the window exists
      WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.title == "Update Add-ons") | .address')
      if [ -n "$WINDOW" ]; then
        hyprctl dispatch closewindow address:$WINDOW
        exit 0
      fi
      sleep 0.1
    done
  '';

in
{
  home.packages = [ pkgs.anki ];
  home.activation.installAnkiAddons =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        $DRY_RUN_CMD ${initAnkiConfig}
        $DRY_RUN_CMD ${installAddons}
      '';
  home.file.".local/share/applications/anki.desktop" = {
    force = true;
    text =
      builtins.replaceStrings
        [ "Exec=anki %f" ]
        [ "Exec=sh -c '${closeAnkiUpdateDialog} & anki'" ]
        (builtins.readFile "${pkgs.anki}/share/applications/anki.desktop");
  };
}
