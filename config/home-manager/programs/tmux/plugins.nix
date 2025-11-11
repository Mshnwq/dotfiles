# programs/tmux/plugins.nix
{
  pkgs,
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
      extraConfig = ''
        source-file ~/.config/tmux/pywal.conf
      '';
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
        set -g @floax-x 'P'
        set -g @floax-y 'P'
        # Options: black, red, green, yellow, blue, magenta, cyan, white
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
