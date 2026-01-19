{
  pkgs,
  config,
  inputs,
  ...
}:
let
  fifo = "/tmp/mpd.fifo";
in
{
  sops.secrets = {
    discogs-key.mode = "0400";
    lastfm-key.mode = "0400";
    mpd-remote-host = {
      mode = "0400";
      path = ''
        ${config.xdg.configHome}/mpd_remote_host"
      '';
    };
  };

  home.packages = with pkgs; [
    beets
    cava
    mpc
    mpd
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
      path   "${fifo}"
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
        mkfifo -m 600 ${fifo} || true
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

  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some, unwrap_newtypes, unwrap_variant_newtypes)]
      (
        theme: "pywal",
        cache_dir: None,
        volume_step: 5,
        max_fps: 30,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        enable_config_hot_reload: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: false,
        album_art: (
          method: Auto,
          max_size_px: (width: 0, height: 0),
          disabled_protocols: ["http://", "https://"],
          vertical_align: Center,
          horizontal_align: Center,
        ),
        keybinds: (
          global: {
            "s": Stop,
            "q": Quit,
            "p": TogglePause,
            ".": SeekForward,
            ",": SeekBack,
            ">": NextTrack,
            "<": PreviousTrack,
            "-": VolumeDown,
            "+": VolumeUp,
            "<Tab>": NextTab,
            "<S-Tab>": PreviousTab,
            "1": SwitchToTab("Playing"),
            "2": SwitchToTab("Artists"),
            "3": SwitchToTab("Albums"),
            "4": SwitchToTab("Lists"),
            "5": SwitchToTab("Find"),
            "6": SwitchToTab("Dir"),
            "z": ToggleRepeat,
            "x": ToggleRandom,
            "c": ToggleSingleOnOff,
            "v": ToggleConsumeOnOff,
            ":": CommandMode,
            "~": ShowHelp,
            "I": ShowCurrentSongInfo,
            "O": ShowOutputs,
            "P": ShowDecoders,
            "r": AddRandom,
          },
          navigation: {
            "k": Up,
            "j": Down,
            "h": Left,
            "l": Right,
            "<Up>": Up,
            "<Down>": Down,
            "<Left>": Left,
            "<Right>": Right,
            "<C-k>": PaneUp,
            "<C-j>": PaneDown,
            "<C-h>": PaneLeft,
            "<C-l>": PaneRight,
            "<C-u>": UpHalf,
            "N": PreviousResult,
            "a": Add,
            "A": AddAll,
            "R": Rename,
            "n": NextResult,
            "g": Top,
            "<Space>": Select,
            "<C-Space>": InvertSelection,
            "G": Bottom,
            "<CR>": Confirm,
            "i": FocusInput,
            "J": MoveDown,
            "<C-d>": DownHalf,
            "/": EnterSearch,
            "<C-c>": Close,
            "<Esc>": Close,
            "K": MoveUp,
            "D": Delete,
          },
          queue: {
            "D": DeleteAll,
            "<CR>": Play,
            "<C-s>": Save,
            "a": AddToPlaylist,
            "d": Delete,
            "i": ShowInfo,
            "C": JumpToCurrent,
          },
        ),
        search: (
          case_sensitive: false,
          mode: Contains,
          tags: [
            (value: "title", label: "Title"),
            (value: "artist", label: "Artist"),
            (value: "album", label: "Album"),
            (value: "genre", label: "Genre"),
            (value: "any", label: "Any Tag"),
          ],
        ),
        artists: (
          album_display_mode: SplitByDate,
          album_sort_by: Date,
        ),
        tabs: [
          (
            name: "Playing",
            pane: Split(
              direction: Horizontal,
              panes: [
                (
                  size: "40%",
                  pane: Pane(AlbumArt),
                ),
                (
                  size: "60%",
                  pane: Pane(Queue),
                ),
              ],
            ),
          ),
          (
            name: "Artists",
            pane: Split(
              direction: Horizontal,
              panes: [
                (
                  size: "40%",
                  pane: Pane(AlbumArt),
                ),
                (
                  size: "60%",
                  pane: Pane(Artists),
                ),
              ],
            ),
          ),
          (
            name: "Albums",
            pane: Split(
              direction: Horizontal,
              panes: [
                (
                  size: "40%",
                  pane: Pane(AlbumArt),
                ),
                (
                  size: "60%",
                  pane: Pane(Albums),
                ),
              ],
            ),
          ),
          (
            name: "Lists",
            pane: Pane(Playlists),
          ),
          (name: "Find", pane: Pane(Search)),
        ],
      )
    '';
  };

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/beets.nix
  programs.beets =
    let
      lastfm-key =
        if
          config.sops.secrets ? "lastfm-key"
          && builtins.pathExists config.sops.secrets."lastfm-key".path
        then
          builtins.readFile config.sops.secrets."lastfm-key".path
        else
          "xxx";
      discogs-key =
        if
          config.sops.secrets ? "discogs-key"
          && builtins.pathExists config.sops.secrets."discogs-key".path
        then
          builtins.readFile config.sops.secrets."discogs-key".path
        else
          "xxx";
    in
    # extract year my plugin
    {
      enable = true;
      settings = {
        directory = "~/Music";
        import = {
          write = true;
          autotag = true;
        };
        paths = {
          default = "$artist/($year) $album/$track $title";
          singleton = "$artist/Other/$title";
          comp = "Compilations/($year) $album/$track $title";
        };
        pluginpath = "~/.config/beets/plugins";
        plugins = [
          # "extract_year"  # my plugins
          "fetchart"
          "embedart"
          "mbsync"
          "edit"
          "lastgenre"
          "discogs"
        ];
        fetchart = {
          lastfm_key = lastfm-key;
          sources = [
            "lastfm"
            # "xxx"
          ];
        };
        discogs = {
          user_token = discogs-key;
        };
      };
    };
}
