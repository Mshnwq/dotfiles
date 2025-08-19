{ config, pkgs, lib, ... }: {
  home.username = "mshnwq";
  home.homeDirectory = "/home/mshnwq";
  home.stateVersion = "25.05";

  targets.genericLinux.enable = true;  # ENABLE THIS ON NON NIXOS

  home.packages = [
    # pkgs.cowsay
    pkgs.btop
    pkgs.fastfetch
    # pkgs.stow
    # pkgs.zoxide
    # pkgs.zathura
  ];

  xdg.enable = true;  # https://wiki.archlinux.org/title/XDG_Base_Directory
  # home.profileDirectory = "$HOME/.local/share/nix/profile"; # Careful
  home.sessionVariables = {
    # NIX_PROFILE_DIR = "${config.home.homeDirectory}/.nix-profile";
    # NIX_PROFILE_DIR = "$HOME/.local/share/nix/profile";
    EDITOR = "vim";
    VISUAL = "vim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
    DISABLE_AUTO_TITLE = "true";
    TERMINFO = "/usr/share/terminfo/";
    YDOTOOL_SOCKET = "$XDG_RUNTIME_DIR/ydotool_socket";
    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc-2.0"; # gtk 3 & 4 are XDG compliant
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    LESSHISTFILE = "${config.xdg.cacheHome}/less_history";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    CUDA_CACHE_PATH = "${config.xdg.stateHome}/nv";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
    # GOPATH = "${config.xdg.dataHome}/go";
    # GOBIN = "${GOPATH}/bin";
    # GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    # WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
    # XINITRC = "${config.xdg.configHome}/x11/xinitrc";
    # XPROFILE = "${config.xdg.configHome}/x11/xprofile";
    # XRESOURCES = "${config.xdg.configHome}/x11/xresources";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
# TODO: clean this mess up
# https://wiki.archlinux.org/title/XDG_Base_Directory
# nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
# https://github.com/BreadOnPenguins/dots/blob/master/.zprofile
