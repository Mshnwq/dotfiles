{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    mpd
    mpc
    rmpc
    cava # TODO: doesnt work on waybar ?
    beets
    pulsemixer
    qpwgraph
  ];

  # https://github.com/nix-community/home-manager/blob/master/modules/services/mpd.nix
  home.file."${config.xdg.configHome}/mpd/mpd.conf".text = ''
    music_directory    "${config.home.homeDirectory}/Music"
    playlist_directory "${config.xdg.dataHome}/mpd/playlists"

    db_file            "${config.xdg.dataHome}/mpd/db"
    pid_file           "${config.xdg.dataHome}/mpd/pid"
    log_file           "${config.xdg.dataHome}/mpd/log"
    sticker_file       "${config.xdg.dataHome}/mpd/sticker.sql"

    state_file         "${config.xdg.stateHome}/mpd/state"

    auto_update        "yes"
    metadata_to_use    "artist,album,title,track,name,genre,date,comment"

    bind_to_address    "127.0.0.1"
    port               "6600"

    audio_output {
      type       "pulse"
      name       "Local Music Player Daemon"
    }

    audio_output {
      type   "fifo"
      name   "my_fifo"
      path   "/tmp/mpd.fifo"
      format "44100:16:2"
    }
  '';
  home.activation.ensureMpdDirs =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        mkdir -p "${config.xdg.dataHome}/mpd"
        chmod 700 "${config.xdg.dataHome}/mpd"
        mkdir -p "${config.xdg.stateHome}/mpd"
        chmod 700 "${config.xdg.stateHome}/mpd"
        mkdir -p "${config.xdg.dataHome}/mpd/playlists"
        mkfifo -m 600 /tmp/mpd.fifo || true
      '';
  systemd.user.services.mpd = {
    Unit = {
      Description = "Music Player Daemon";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${config.xdg.configHome}/mpd/mpd.conf";
      Restart = "always";
    };
    Install = { }; # empty so it won’t auto-start
  };

  programs.beets = {
    # enable = true;
    enable = false;
    settings = ''
      directory: ~/Music
      import:
        write: yes
        autotag: yes
      paths:
        default: $artist/($year) $album/$track $title
        singleton: $artist/Other/$title
        comp: Compilations/($year) $album/$track $title
      pluginpath: ~/.config/beets/plugins
      plugins:
        - extract_year # my plugin
        - fetchart
        - embedart
        - mbsync
        - edit
        - lastgenre
        - discogs
      }
    '';
  };
}
