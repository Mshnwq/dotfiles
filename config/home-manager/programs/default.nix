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
    home.packages =
      with pkgs;
      [
        cmatrix
        cowsay
        cmatrix
        dialog
        qimgv # TODO: bootstrap settings
        mtpfs
        simple-mtpfs
        lm_sensors
        zathura
      ]
      ++ lib.optionals inputs.useSops [
        sops
        age
      ];
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
      nmap
      buku
      # --import bookmarks.db
    ];
  };

  # language
  anki = {
    home.packages = with pkgs; [
      anki
    ];
    # ANKI_WAYLAND = "1";
  };
}
