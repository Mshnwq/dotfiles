# user.nix
args@{
  self,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  username = "mshnwq";
in
{
  home.username = username;
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true; # ENABLE THIS ON NON NIXOS

  # https://wiki.archlinux.org/title/XDG_Base_Directory
  xdg.enable = true;
  home.sessionVariables = {
    YDOTOOL_SOCKET = "$XDG_RUNTIME_DIR/ydotool_socket";
    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc-2.0";
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    LESSHISTFILE = "${config.xdg.cacheHome}/less_history";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    CUDA_CACHE_PATH = "${config.xdg.stateHome}/nv";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    NPM_CONFIG_PREFIX = "${config.xdg.dataHome}";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    # GOPATH = "${config.xdg.dataHome}/go";
    # GOBIN = "${GOPATH}/bin";
    # GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    # WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
    # XINITRC = "${config.xdg.configHome}/x11/xinitrc";
    # XPROFILE = "${config.xdg.configHome}/x11/xprofile";
    # XRESOURCES = "${config.xdg.configHome}/x11/xresources";
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    TERMINFO = "/usr/share/terminfo/";
    DISABLE_AUTO_TITLE = "true";
  };

  imports =
    let
      user = lib.importDir' ./. "user.nix";
      programs = user.programs args;
    in
    with programs;
    [
      mpv
      vim
      pass
      auto
      rust
      mime
      wine
      music
      pywal
      infra
      neovim
      devenv
      default
      flatpak
      firefox
      obsidian
      keyboard.vial
      keyboard.kmonad
      discord.stable
      hypr
      {
        hypr.hyprWorkspaceLayouts.enable = true;
      }
      zsh
      {
        zsh.debug.enable = true;
        zsh.pluginSettings = {
          history-substring-search.enable = true;
          syntax-highlighting.enable = true;
          autosuggestions.enable = true;
          nix-shell.enable = true;
          fzf-tab.enable = true;
          fzf.enable = true;
        };
      }
      tmux
      {
        tmux.tmuxp.enable = true;
        tmux.systemShell.enable = true;
        tmux.pluginSettings = {
          dracula.enable = true;
          floax.enable = true;
          yank.enable = true;
          fzf.enable = true;
        };
      }
      yazi
      {
        yazi.sops.enable = true;
        yazi.pluginSettings = {
          relative-motions.enable = true;
          jump-to-char.enable = true;
          mediainfo.enable = true;
          projects.enable = true;
          restore.enable = true;
          dupes.enable = true;
          yamb.enable = true;
        };
      }
    ]
    ++ [
      inputs.sops-nix.homeManagerModules.sops
    ];

  sops =
    let
      # NOTE: change to own key and secret
      ageKeyfile =
        if inputs.useSops then
          "${config.xdg.configHome}/sops/age/keys.txt"
        else
          "${config.xdg.configHome}/sops/age/dummy.txt";
      sopsFile =
        if inputs.useSops then ./secrets/primary.yaml else ./secrets/dummy.yaml;
    in
    {
      age.keyFile = ageKeyfile;
      defaultSopsFile = sopsFile;
      defaultSopsFormat = "yaml";
      secrets = {
        browser-pinned = {
          mode = "0400";
        };
        yazi-goto = {
          mode = "0400";
        };
        tmuxp = {
          mode = "0400";
        };
        lastfm-key = {
          mode = "0400";
        };
        discogs-key = {
          mode = "0400";
        };
        mpd-remote-host = {
          mode = "0400";
          path = "${config.xdg.configHome}/mpd_remote_host";
        };
        tampermonkey = {
          mode = "0400";
          path = "${config.xdg.configHome}/tampermonkey.txt";
        };
        ssh-config = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/config";
        };
        gitlab-ssh-priv = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/gitlab";
        };
        gitlab-ssh-pub = {
          mode = "0444";
          path = "${config.home.homeDirectory}/.ssh/gitlab.pub";
        };
        github-ssh-priv = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/github";
        };
        github-ssh-pub = {
          mode = "0444";
          path = "${config.home.homeDirectory}/.ssh/github.pub";
        };
      };
    };

  programs.git = {
    enable = true;
    signing = {
      key = "3387826BA9F3479C5B1EC96574D232B4C78840C9";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "mshnwq";
        email = "mshnwq.com@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      tag = {
        gpgSign = true;
      };
      rerere = {
        enabled = true;
      };
      credential = {
        helper = "cache --timeout=36000";
      };
      core = {
        editor = "vim";
      };
    };
  };
}
