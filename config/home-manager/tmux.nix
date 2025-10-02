{ config, pkgs, ... }:
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
in {
  home.packages = [ pkgs.tmux pkgs.tmuxp ];
  home.sessionVariables = {
    TMUXP_CONFIGDIR = "${config.xdg.configHome}/tmux/tmuxp";
  };
  programs.tmux = {
    enable = true;
    shell = "/usr/bin/zsh";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    historyLimit = 1000;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    shortcut = "Space";
    tmuxp.enable = true;
    plugins = with pkgs; [
      {
        plugin = tmux-dracula;
        extraConfig = ''
          source-file ~/.config/tmux/pywal.conf
        '';
      }
      {
        plugin = tmux-floax;
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
      }
      {
        plugin = tmuxPlugins.tmux-fzf;
        extraConfig = ''
          TMUX_FZF_LAUNCH_KEY="z"
        '';
      }
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_with_mouse on
        '';
      }
    ];
    extraConfig = ''
      # --------------------#
      #     Keybindings     #
      # --------------------#

      # reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!" # quick reload

      # window spliting
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"

      # pane swapping ctrl + Space && shift + arrows
      bind -r S-Down resize-pane -D 15
      bind -r S-Up resize-pane -U 15
      bind -r S-Left resize-pane -L 15
      bind -r S-Right resize-pane -R 15

      bind j choose-window 'join-pane -h -s "%%"'
      bind J choose-window 'join-pane -s "%%"'

      # keep current path on new window
      bind c new-window -c "#{pane_current_path}"

      # window swapping
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1
      bind Space last-window

      # my special binds
      bind-key k clock-mode
      # setw -g clock-mode-colour colour5
      unbind t
      bind-key t choose-tree -Zw
      unbind q
      bind-key q kill-window
      unbind w
      bind-key w kill-pane
      bind-key a display-panes
      bind-key b command-prompt -I "#S" "rename-session -- '%%'"

      unbind n
      unbind ,
      unbind .
      bind-key n command-prompt -I "#W" "rename-window -- '%%'"
      bind-key , previous-window
      bind-key . next-window

      # kill
      bind-key W command-prompt -I "kill-session" 
      bind-key Q command-prompt -I "kill-server" 

      unbind C
      bind-key C command-prompt -I "new-session" 
      # session swap
      bind-key C-Space switch-client -l

      # --------------------#
      #       Options       #
      # --------------------#

      # Set default status bar postion
      set -g status-position top

      # Define a key binding to toggle the status bar position
      bind-key "^" if-shell "test #{status-position} = bottom" "set-option -g status-position top" "set-option -g status-position bottom"

      # Map ! to switch to window 1
      bind-key ! break-pane

      bind-key '1' select-window -t 1
      bind-key '2' select-window -t 2
      bind-key '3' select-window -t 3
      bind-key '4' select-window -t 4
      bind-key '5' select-window -t 5
      bind-key '6' select-window -t 6
      bind-key '7' select-window -t 7
      bind-key '8' select-window -t 8
      bind-key '9' select-window -t 9
      bind-key ')' select-window -t 0
    '';
  };
}
