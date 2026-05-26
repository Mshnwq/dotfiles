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
      # wine
      anki
      hypr
      email
      # {
      #   which-key.enable = true;
      # }
      music
      pywal
      infra
      neovim
      devenv
      default
      firefox
      keyboard.vial
      keyboard.kmonad
      discord.stable
      # TODO: get mischa ai cli and claude code ??
      obsidian
      {
        nvim.enable = true;
        syncthing.enable = true;
        which-key.enable = true;
      }
      zsh
      {
        zsh = {
          debug.enable = false;
          direnv.enable = true;
          pluginSettings = {
            history-substring-search.enable = true;
            syntax-highlighting.enable = true;
            autosuggestions.enable = true;
            nix-shell.enable = true;
            fzf-tab.enable = true;
            fzf.enable = true;
          };
        };
      }
      tmux
      {
        tmux = {
          tmuxp.enable = true;
          server.enable = false;
          systemShell.enable = true;
          pluginSettings = {
            dracula.enable = true;
            floax.enable = true;
            yank.enable = true;
            fzf.enable = true;
          };
        };
      }
      yazi
      {
        yazi = {
          sops.enable = true;
          pluginSettings = {
            relative-motions.enable = true;
            jump-to-char.enable = true;
            preview-epub.enable = true;
            mediainfo.enable = true;
            projects.enable = true;
            restore.enable = true;
            dupes.enable = true;
            yamb.enable = true;
            zoom.enable = false;
          };
        };
      }
    ]
    ++ [
      inputs.sops-nix.homeManagerModules.sops
      ./modules/which-key.nix
    ];
  programs.which-key = {
    enable = true;
    entries = [
      {
        key = "k";
        desc = "Keepass";
        cmd = "gtk-launch keepassxc";
      }
      {
        key = "t";
        desc = "Telegram";
        cmd = " flatpak run org.telegram.desktop";
      }
      {
        key = "x";
        desc = "Executer";
        submenu = [
          {
            key = "d";
            desc = "Daemons";
            cmd = "~/.local/bin/Executer --daemons";
          }
          {
            key = "p";
            desc = "Procs";
            cmd = "~/.local/bin/Executer --procs";
          }
          {
            key = "v";
            desc = "VPN";
            cmd = "~/.local/bin/Executer --vpn";
          }
          {
            key = "w";
            desc = "Wal";
            cmd = "~/.local/bin/Executer --wal";
          }
        ];
      }
    ];
  };

  sops =
    let
      # NOTE: change to own key and secret
      ageDir = "${config.xdg.configHome}/sops/age";
      ageKeyfile =
        if inputs.useSops then "${ageDir}/keys.txt" else "${ageDir}/dummy.txt";
      sopsFile =
        if inputs.useSops then ./secrets/primary.yaml else ./secrets/dummy.yaml;
      sshDir = "${config.home.homeDirectory}/.ssh";
      mkSecret = name: path: {
        inherit name;
        value = {
          mode = if builtins.match ".*\\.pub$" path != null then "0444" else "0400";
          inherit path;
        };
      };
    in
    {
      age.keyFile = ageKeyfile;
      defaultSopsFile = sopsFile;
      defaultSopsFormat = "yaml";
      secrets = builtins.listToAttrs [
        (mkSecret "mounts-conf" "${config.xdg.configHome}/mounts.conf")
        (mkSecret "ssh-config" "${sshDir}/config")
        (mkSecret "gitlab-ssh-priv" "${sshDir}/gitlab")
        (mkSecret "gitlab-ssh-pub" "${sshDir}/gitlab.pub")
        (mkSecret "github-ssh-priv" "${sshDir}/github")
        (mkSecret "github-ssh-pub" "${sshDir}/github.pub")
      ];
    };
}

# l | awk '{print $9}' | sed "s|nix/store/||" | sed "s|/bin/.*||" | cut -d "-" -f 2- | awk '!seen[$1]++' | sort | wc -l

# l | awk '{print $9}' \
# | sed 's|^/nix/store/||; s|/bin/.*||' \
# | cut -d- -f2- \
# | awk '{count[$0]++} END {for (p in count) printf "%3d %s\n", count[p], p}' \
# | sort -nr | wc -l
