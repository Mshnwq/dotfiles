args@{ self, lib, pkgs, config, inputs, ... }:
(lib.mapAttrs (_: expr: if lib.isFunction expr then expr args else expr)
  (lib.importDir' ./. "default.nix")) // {

    telegram = { home.packages = [ pkgs.tdesktop ]; };

    element = { home.packages = [ pkgs.element-desktop ]; };

    mattermost = { home.packages = [ pkgs.mattermost-desktop ]; };

    obs-studio = {
      programs.obs-studio.enable = true;
      programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-move-transition
        obs-backgroundremoval
      ];
      # needed for screen selection on wayland
      home.packages = [ pkgs.slurp ];
    };
  }
