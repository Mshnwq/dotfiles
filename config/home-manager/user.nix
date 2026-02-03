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

  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    TERMINFO = "/usr/share/terminfo/";
    DISABLE_AUTO_TITLE = "true";
    # https://wiki.archlinux.org/title/XDG_Base_Directory
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

  imports =
    let
      user = lib.importDir' ./. "user.nix";
      programs = user.programs args;
    in
    with programs;
    [
      mpv
      vim
      git
      daw
      news
      pass
      auto
      rust
      mime
      wine
      anki
      music
      pywal
      infra
      neovim
      devenv
      default
      firefox
      # email
      discord.stable
      keyboard.vial
      keyboard.kmonad
      # TODO: |
      # get email.nix (aerc,neomutt), {w3m,browser}.nix
      # get mischa ai cli and claude code ??
      # start using obsidian
      obsidian
      {
        obsidian.syncthing.enable = true;
      }
      hypr
      {
        hypr.hyprWorkspaceLayouts.enable = true;
      }
      zsh
      {
        zsh.debug.enable = false;
        zsh.direnv.enable = true;
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
        tmux.server.enable = false;
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
          zoom.enable = false;
        };
      }
    ]
    ++ [
      inputs.sops-nix.homeManagerModules.sops
    ];

  sops =
    let
      # NOTE: change to own key and secret
      ageDir = "${config.xdg.configHome}/sops/age";
      ageKeyfile =
        if inputs.useSops then "${ageDir}/keys.txt" else "${ageDir}/dummy.txt";
      sopsFile =
        if inputs.useSops then ./secrets/primary.yaml else ./secrets/dummy.yaml;
    in
    {
      age.keyFile = ageKeyfile;
      defaultSopsFile = sopsFile;
      defaultSopsFormat = "yaml";
      secrets = {
        mounts-conf = {
          mode = "0400";
          path = "${config.xdg.configHome}/mounts.conf";
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
}

# l | awk '{print $9}' | sed "s|nix/store/||" | sed "s|/bin/.*||" | cut -d "-" -f 2- | awk '!seen[$1]++' | sort | wc -l

# l | awk '{print $9}' \
# | sed 's|^/nix/store/||; s|/bin/.*||' \
# | cut -d- -f2- \
# | awk '{count[$0]++} END {for (p in count) printf "%3d %s\n", count[p], p}' \
# | sort -nr | wc -l
