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
      # cowsay
      cmatrix
      # TODO: broked
      # mtpfs
      # simple-mtpfs
      lm_sensors
      zathura
    ];
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "pywal";
        theme_background = false;
        presets = "proc:1:default";
      };
    };
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
      newsboat
    ];
  };

  # rust tools
  rust = {
    home.packages = with pkgs; [
      cargo
      rustc
      gpg-tui
      serie
      # termscp
    ];
  };

  # language
  # anki = {
  #   home.packages = with pkgs; [
  #     anki
  #   ];
  #   # ANKI_WAYLAND = "1";
  # };
}
