# programs/default.nix
args@{
  self,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
(lib.mapAttrs (_: expr: if lib.isFunction expr then expr args else expr) (
  lib.importDir' ./. "default.nix"
))
// {

  default = {
    home.packages = with pkgs; [
      age
      sops
      dialog
      zathura
      cmatrix
      lm_sensors
      networkmanager_dmenu
      # TODO: broked
      # mtpfs
      # simple-mtpfs
      (pkgs.symlinkJoin {
        name = "rofi-bluetooth-wrapped";
        buildInputs = [ pkgs.makeWrapper ];
        paths = [ pkgs.rofi-bluetooth ];
        postBuild = ''
          wrapProgram $out/bin/rofi-bluetooth \
            --add-flags "-- -theme ${config.xdg.configHome}/rofi/Bluetooth.rasi"
        '';
      })
    ];

    # https://wiki.archlinux.org/title/NetworkManager#Set_up_PolicyKit_permissions
    home.file.".config/networkmanager-dmenu/config.ini".source =
      pkgs.runCommand "NetManagerDM.ini" { }
        ''
          ${pkgs.gnused}/bin/sed \
            -e "s|bspwm/config/rofi-themes|rofi|" \
            -e "s/pinentry =/pinentry = pinentry-qt/" \
            ${
              pkgs.fetchurl {
                url =
                  "https://raw.githubusercontent.com/gh0stzk/dotfiles/"
                  + "7fe6e5966ebcc51110855ff5e82dadc601393ae9/"
                  + "config/bspwm/config/NetManagerDM.ini";
                sha256 = "sha256-X1sucruwzSZiM3Qo3ydVZiRMX/5jjDQ+TduST8M9xU4=";
              }
            } > $out
        '';

    # home.file.".config/rofi-buku.config".text = ''
    #   #!/usr/bin/env bash
    #   _rofi () {
    #     rofi -dmenu -i -no-levenshtein-sort -width 1000 \
    #       -theme "${config.xdg.configHome}/rofi/Buku.rasi" "$@"
    #   }
    #   # display settings
    #   display_type=3
    #   max_str_width=35
    #   # keybindings
    #   switch_view="Alt+Tab"
    #   new_bookmark="Alt+n"
    #   actions="Alt+a"
    #   edit="Alt+e"
    #   delete="Alt+d"
    #   # colors
    #   help_color="#2d7ed8"
    # '';

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "pywal";
        theme_background = false;
        presets = "proc:1:default";
      };
    };

    # home.activation.flatpakOptions =
    #   inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
    #     ''
    #       ov_dir="${config.xdg.dataHome}/flatpak/overrides"
    #       mkdir -p "$ov_dir"
    #       winezgui_ov="$ov_dir/io.github.fastrizwaan.WineZGUI"
    #       if [ ! -f "$winezgui_ov" ]; then
    #         cat > "$winezgui_ov" <<EOF
    #       [Context]
    #       sockets=wayland
    #       EOF
    #       fi
    #       anki_ov="$ov_dir/net.ankiweb.Anki"
    #       if [ ! -f "$anki_ov" ]; then
    #         cat > "$anki_ov" <<EOF
    #       [Context]
    #       devices=!dri
    #       [Environment]
    #       ANKI_WAYLAND=1
    #       EOF
    #       fi
    #     '';
  };

  vim = {
    programs.vim = {
      enable = true;
      packageConfigurable = pkgs.vim;
      extraConfig = ''
        set viminfo+=n~/.config/viminfo
        autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
      '';
    };
    # https://github.com/vim/vim/issues/5157
    # home.file.".local/bin/vim" = {
    #   executable = true;
    #   text = ''
    #     #!/usr/bin/env sh
    #     env -u XDG_SEAT -a vim ${config.programs.vim.package}/bin/vim "$@"
    #   '';
    # };
  };

  devenv = {
    home.packages = [
      pkgs.direnv
      inputs.devenv.packages.x86_64-linux.devenv
    ];
    home.file."${config.xdg.configHome}/direnv/config.toml" = {
      force = true;
      text = ''
        [global]
        log_format = "-"
        log_filter = "^$"
      '';
    };
    home.file."${config.xdg.configHome}/npm/npmrc" = {
      force = true;
      text = ''
        prefix=$XDG_DATA_HOME/npm
        cache=$XDG_CACHE_HOME/npm
        init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
        logs-dir=$XDG_STATE_HOME/npm/logs
      '';
    };
  };

  # automation tools
  auto = {
    home.packages = with pkgs; [
      gallery-dl
      yt-dlp
      rclone
      jdupes
      # aria2
      # wireshark # TODO: try on other device it brok my wi-fi
      nmap
      buku
      # --import bookmarks.db
    ];
  };

  # rust tools
  rust = {
    home.packages = with pkgs; [
      cargo
      rustc
      serie # crashes on nixpkgs
      guitar # from /pkgs/; doest crash baut laggy
      gpg-tui
      # termscp
    ];
  };

  # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.anki
  anki = {
    home.packages = with pkgs; [
      anki
    ];
    programs.anki = {
      enable = false;
      # theme = "followSystem";
      # style = "native";
      # minimalistMode = true;
      addons = with pkgs.ankiAddons; [
        review-heatmap
        anki-connect
        # recolor
        (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
          pname = "recolor";
          version = "12e42fc";
          src = pkgs.fetchFromGitHub {
            owner = "AnKing-VIP";
            repo = "AnkiRecolor";
            rev = finalAttrs.version;
            hash = "sha256-TbDUVCfqDXQmCwRgDW+hLZPfIElQAW2wFFgWOc3iKiU=";
            sparseCheckout = [ "src/addon" ];
          };
          sourceRoot = "${finalAttrs.src.name}/src/addon";
        }))
        (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
          pname = "anking-bg";
          version = "9706a8f";
          src = pkgs.fetchFromGitHub {
            owner = "AnKing-VIP";
            repo = "Custom-background-image-and-gear-icon";
            rev = finalAttrs.version;
            hash = "sha256-v9/WR+3DK9+byudHFAtsCsPW3WmRVY003+ufEqIFIxM=";
            sparseCheckout = [ "addon" ];
          };
          sourceRoot = "${finalAttrs.src.name}/addon";
        }))
      ];
    };
  };

  # digital audio workstation
  daw = {
    home.packages = with pkgs; [
      audacity # WAYLAND is in v4 pre release still maybe overlay it
      qpwgraph
      pulsemixer
      # bespokesynth # flatpak is better
      lmms # from /overlays/;
      #odin2
      #vital
      #cardinal
      ardour
    ];
  };
  xdg.desktopEntries.qpwgraph = {
    name = "qpwgraph";
    exec = "qpwgraph %f";
    icon = "org.rncbc.qpwgraph";
    categories = [
      "Audio"
      "Midi"
      "X-Alsa"
      "X-Pipewire"
    ];
    type = "Application";
    startupNotify = true;
    mimeType = [
      "application/x-qpwgraph-patchbay"
    ];
  };
}
