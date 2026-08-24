# programs/anki.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let

  lowerFirst =
    s: lib.toLower (lib.substring 0 1 s) + lib.substring 1 (lib.stringLength s) s;
  entry = key: desc: cmd: { inherit key desc cmd; };
  menu = key: desc: submenu: { inherit key desc submenu; };
  gtt =
    key: desc: entry key desc "~/.local/bin/executer/.gtt.sh --${lowerFirst desc}";

  profileName = config.home.username;
  cfgDir = "${config.xdg.dataHome}/Anki2";

  # QtWebEngine's zero-copy compositing path segfaults on this machine:
  # NativeSkiaOutputDeviceOpenGL::texture() -> _mesa_TexStorageMem2DEXT ->
  # iris_resource_from_memobj derefs NULL, killing Anki a second or two after
  # the media server comes up. Disabling only GPU *compositing* dodges the
  # shared-texture import while leaving rasterisation and video decode on GPU
  # (--disable-gpu also works but forces full software rendering).
  # ankiPkg = pkgs.symlinkJoin {
  #   name = "anki-${pkgs.anki.version}-wrapped";
  #   paths = [ pkgs.anki ];
  #   nativeBuildInputs = [ pkgs.makeWrapper ];
  #   postBuild = ''
  #     wrapProgram $out/bin/anki \
  #       --prefix QTWEBENGINE_CHROMIUM_FLAGS " " "--disable-gpu-compositing"
  #   '';
  # };
  # Locally authored add-on, assembled here because Anki wants a directory
  # with __init__.py + manifest.json while the source lives as one flat file
  # next to this module (programs/ subdirectories are auto-imported as Nix
  # modules, so the add-on cannot be a directory in here).
  transparentManifest = pkgs.writeText "manifest.json" (
    builtins.toJSON {
      package = "pywal_transparent";
      name = "Pywal Transparent";
      mod = 0;
    }
  );
  transparentAddon = pkgs.runCommand "anki-addon-transparent" { } ''
    mkdir -p $out
    cp ${./anki-transparent.py} $out/__init__.py
    cp ${transparentManifest} $out/manifest.json
  '';

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

    # # https://github.com/sajee05/anki_obsidian_sync
    # # One-way Anki -> Obsidian mirror: exports the collection to markdown so
    # # cards are searchable/linkable in the vault. Nothing flows back; edits to
    # # generated files are overwritten on the next run.
    # #
    # # NOTE: obsolete notes are removed with Path.unlink(), i.e. deleted
    # # outright, not sent to the recycle bin as the README claims. Deletion is
    # # scoped to obsidianSyncPath, so that folder must be one the addon owns
    # # exclusively -- never a folder holding hand-written notes.
    # {
    #   id = "1162061440";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "sajee05";
    #     repo = "anki_obsidian_sync";
    #     rev = "22e48e4debe541269fe917ad0d005eec5bc88b87";
    #     hash = "sha256-c62wmjK7u7RVjczuSul6HXgqM15WRDj6i82xM0+vfTM=";
    #   };
    #   sourcedir = "";
    #   extraRun = ''
    #     # 36MB of demo media that would otherwise live in addons21 forever.
    #     rm -f "$ADDON_DEST/demo.gif" "$ADDON_DEST"/SS*.png
    #     # Upstream ships the author's own Windows path and UPSC deck list as
    #     # defaults. Blank it so a sync cannot run until it is pointed
    #     # somewhere deliberately, via Tools -> Add-ons -> Config.
    #     echo '{"obsidianSyncPath": "", "excludedDecks": []}' \
    #       > "$ADDON_DEST/config.json"
    #     # Keep [sound:...] out of generated filenames; see the script header.
    #     ${pkgs.python3}/bin/python3 ${./anki-obsidian-sync-filename.py} \
    #       "$ADDON_DEST/state_builder.py"
    #   '';
    # }

    # Real window transparency: the compositor's wallpaper and blur show
    # through Anki, rather than a wallpaper being painted inside the window
    # (which is what AnKing's Custom-background-image add-on used to do here).
    {
      id = "pywal_transparent";
      src = transparentAddon;
      sourcedir = "";
      # Local add-on: re-copy on every switch so edits to the source file
      # actually reach the profile.
      force = true;
      extraRun = "";
    }
  ];

  # # Add-ons that were installed by an earlier revision of this module. The
  # # install step below only ever copies, so dropping an entry from `addons`
  # # would otherwise leave it running forever in the live profile.
  # removedAddons = [
  #   "1210908941" # AnKing Custom-background-image-and-gear-icon
  # ];
  #
  # installAddons = pkgs.writeShellScript "install-anki-addons" ''
  #   ADDONS_DIR="${cfgDir}/addons21"
  #   mkdir -p "$ADDONS_DIR"
  #   ${lib.concatMapStringsSep "\n" (id: ''
  #     if [[ -d "$ADDONS_DIR/${id}" ]]; then
  #       rm -rf "$ADDONS_DIR/${id}"
  #       echo "Removed ${id} (no longer managed)"
  #     fi
  #   '') removedAddons}
  #   ${lib.concatMapStringsSep "\n" (addon: ''
  #     ADDON_SRC="${addon.src}/${addon.sourcedir}"
  #     ADDON_DEST="$ADDONS_DIR/${addon.id}"
  #     if [[ -d $ADDON_SRC ]]; then
  #       if [[ -d $ADDON_DEST && ${
  #         if addon.force or false then "1" else "0"
  #       } -eq 0 ]]; then
  #         echo "Skipping ${addon.id} (already installed)"
  #       else
  #         rm -rf "$ADDON_DEST"
  #         cp -r "$ADDON_SRC" "$ADDON_DEST"
  #         chmod -R u+w "$ADDON_DEST"
  #         echo "Installed ${addon.id} to $ADDON_DEST"
  #         ${addon.extraRun}
  #       fi
  #     else
  #       echo "Warning: Source directory not found for ${addon.id}"
  #     fi
  #   '') addons}
  # '';
  #
  # # https://github.com/nix-community/home-manager/blob/master/modules/programs/anki/helper.nix
  # # https://devotd.wordpress.com/2021/02/10/anki-decks-in-python-import-export/
  # initAnkiConfig = pkgs.writeShellScript "init-anki-config" ''
  #   if [[ ! -f "${cfgDir}/prefs21.db" ]]; then
  #     mkdir -p "${cfgDir}"
  #     echo "sh: Initializing Anki configuration..."
  #     export PYTHONPATH="${pkgs.anki.lib}/lib/python${pkgs.python3.pythonVersion}/site-packages:$PYTHONPATH"
  #     ${pkgs.python3}/bin/python3 <<'EOF'
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
    for i in {1..25}; do
      # Check if the window exists
      WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.title == "Update Add-ons") | .address')
      if [[ -n $WINDOW ]]; then
        hyprctl dispatch "hl.dsp.window.close($WINDOW)"
        exit 0
      fi
      sleep 0.2
    done
  '';
in
{
  sops.secrets = {
    gtt-languages = {
      mode = "0400";
      path = "${config.xdg.configHome}/gtt_languages";
    };
  };
  home.file.".config/gtt/keymap.yaml".text = ''
    exit: C-q
    clear: C-c
    translate: C-j
    swap_language: C-s
    copy_selected: C-y
    copy_source: C-g
    copy_destination: C-r
    tts_source: C-o
    tts_destination: C-p
    stop_tts: C-x
    toggle_transparent: C-t
    toggle_below: C-\
  '';

  home.packages = with pkgs; [
    (writeShellScriptBin "gtt" ''
      export ALSA_PLUGIN_DIR=${alsa-plugins}/lib/alsa-lib
      exec ${gtt}/bin/gtt "$@"
    '')
    ankiPkg
  ];
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
        [ "Exec=sh -c '${closeAnkiUpdateDialog} & ${ankiPkg}/bin/anki'" ]
        (builtins.readFile "${pkgs.anki}/share/applications/anki.desktop");
  };
  programs.which-key.entries = [
    (entry "a" "Anki" "gtk-launch anki")
    (menu "T" "Translate" [
      (gtt "x" "Extract")
      (gtt "a" "Anki")
      (gtt "o" "Obsidian")
    ])
  ];
}
