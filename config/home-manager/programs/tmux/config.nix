# programs/tmux/config.nix
{
  ...
}:
''
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
''
