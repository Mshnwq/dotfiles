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
      networkmanager_dmenu
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
    ];
  };

  # rust tools
  rust = {
    home.packages = with pkgs; [
      cargo
      rustc
      serie
      gpg-tui
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
