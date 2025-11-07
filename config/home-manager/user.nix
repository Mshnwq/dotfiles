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

  home.packages = with pkgs; [
    cowsay
    cmatrix
    dialog
    qimgv
    mtpfs
    simple-mtpfs
    lm_sensors
    zathura
    sops
    age
  ];

  # https://wiki.archlinux.org/title/XDG_Base_Directory
  xdg.enable = true;

  # home.profileDirectory = "$HOME/.local/share/nix/profile"; # Careful
  home.sessionVariables = {
    # NIX_PROFILE_DIR = "${config.home.homeDirectory}/.nix-profile";
    # NIX_PROFILE_DIR = "$HOME/.local/share/nix/profile";
    YDOTOOL_SOCKET = "$XDG_RUNTIME_DIR/ydotool_socket";
    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc-2.0"; # gtk 3 & 4 are XDG compliant
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
  # TODO: clean this mess up
  # nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
  # https://github.com/BreadOnPenguins/dots/blob/master/.zprofile

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
    [
      inputs.sops-nix.homeManagerModules.sops
    ]
    ++ (with programs; [
      devenv
      mpv
      qmk
      vim
      neovim
      firefox
      obsidian
      pass
      auto
      music
      shell
      tmux
      yazi
      pywal
      rust
      infra
      mime
      hypr
      flat
      # anki
      discord.stable
      # discord.canary
    ]);

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      glim-token = { };
    };
  };
}
