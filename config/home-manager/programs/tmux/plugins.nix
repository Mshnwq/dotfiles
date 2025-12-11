# programs/tmux/plugins.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  tmux-dracula = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "dracula";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "mshnwq";
      repo = "tmux-dracula";
      rev = "ae4e0a0de7a1f4a993039a96a6ec77a5c1f4b36a";
      hash = "sha256-KpQTjPfUd42Q5ZaQdN7k5C+b1Mz5sJ29m6u5spywt34=";
    };
  };
  tmux-floax = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "floax";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "mshnwq";
      repo = "tmux-floax";
      rev = "1b23c5758ac8ba439fe3e70bb65a65247c32a3eb";
      hash = "sha256-s1jUx6HFgtVwTjdiAtMLw42//yfLsCEjqgdyQNF+P7c=";
    };
  };
in
{
  plugins = {
    dracula = {
      plugin = tmux-dracula;
      defaultEnable = false;
      extraConfig = lib.concatStringsSep "\n" [
        ''
          source-file ~/.config/tmux/pywal.conf
          set -g @dracula-show-powerline true
          set -g @dracula-border-contrast true
          set -g @dracula-show-flags true
          set -g @dracula-show-left-icon session
          set -g @dracula-clients-minimum 1
          set -g @dracula-transparent-powerline-bg true
          set -g @dracula-invert-select-window-fg true
        ''
        (
          if config.tmux.server.enable then
            ''
              set -g @dracula-show-left-sep \ue0b8
              set -g @dracula-show-right-sep \ue0ba
              set -g @dracula-inverse-divider \ue0be
              set -g @dracula-plugins "network-public-ip"
              set -g @dracula-network-public-ip-colors "mpc_bg mpc_fg"
            ''
          else
            ''
              set -g @dracula-show-left-sep \ue0bc
              set -g @dracula-show-right-sep \ue0be
              set -g @dracula-inverse-divider \ue0ba
              set -g @dracula-plugins "kitty"
              set -g @dracula-kitty-colors "mpc_bg mpc_fg"
            ''
        )
      ];
    };
    floax = {
      plugin = tmux-floax;
      defaultEnable = false;
      extraConfig = ''
        # M- means "hold Meta/Alt"
        set -g @floax-bind '-n M-p'
        set -g @floax-bind-menu 'P'
        set -g @floax-width '50%'
        set -g @floax-height '50%'
        # set -g @floax-x 'R'
        # lower left
        set -g @floax-x 'P'
        set -g @floax-y 'P'
        # Options: black, red
        set -g @floax-border-color 'blue'
        set -g @floax-text-color 'white'
        set -g @floax-change-path 'false'
        set -g @floax-session-name 'floax'
        set -g @floax-title '─'
      '';
    };
    yank = {
      plugin = pkgs.tmuxPlugins.yank;
      defaultEnable = false;
      extraConfig = ''
        set -g @yank_with_mouse on
      '';
    };
    fzf = {
      plugin = pkgs.tmuxPlugins.tmux-fzf;
      defaultEnable = false;
      extraConfig = ''
        TMUX_FZF_LAUNCH_KEY="z"
      '';
    };
  };
}
