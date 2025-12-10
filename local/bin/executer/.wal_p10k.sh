#!/usr/bin/env bash

p10k_file="$HOME/.config/zsh/.p10k.zsh"
p10k_theme="$HOME/.cache/wal/custom-p10k.sh"

sed -i '/# -- start replace from rice/,/# -- end replace from rice/{
  /# -- start replace from rice/!{/# -- end replace from rice/!d}
}' "$p10k_file"

# Read the theme file into a variable
theme_block="$(<"$p10k_theme")"

# Rewrite the .p10k.zsh file with the new block inserted between the markers
awk -v block="$theme_block" '
  BEGIN { in_block = 0 }
  {
    if ($0 ~ /# -- start replace from rice/) {
      print $0
      print block
      in_block = 1
      next
    }
    if ($0 ~ /# -- end replace from rice/) {
      in_block = 0
    }
    if (!in_block) {
      print $0
    }
  }
' "$p10k_file" >"${p10k_file}.tmp" && mv "${p10k_file}.tmp" "$p10k_file"

sleep 0.2
COMMAND="source $XDG_CONFIG_HOME/zsh/.p10k.zsh; clear"

for socket in "$XDG_RUNTIME_DIR"/kitty_socket-*; do
  # List all windows for this socket
  json=$(kitten @ --to "unix:$socket" ls)
  # Extract each window with its ID and foreground_processes
  echo "$json" | jq -c '.[] | .tabs[]?.windows[]? | {id: .id, foreground_processes: .foreground_processes, socket: "'"$socket"'"}' |
    while IFS= read -r window; do
      fg_count=$(echo "$window" | jq '.foreground_processes | length')
      if [[ "$fg_count" -eq 1 ]]; then
        cmd=$(echo "$window" | jq -r '.foreground_processes[0].cmdline[0]')
        if [[ "$cmd" == *"zsh" ]]; then
          win_id=$(echo "$window" | jq -r '.id')
          sock=$(echo "$window" | jq -r '.socket')
          echo "Reloading p10k in window $win_id on socket $sock"
          kitten @ --to "unix:$sock" send-text --match id:"$win_id" "$COMMAND"
        fi
      fi
    done
done

# also implement one for init-term tmux
SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
if [ -S "$SOCKET_FILE" ]; then
  echo "refreshing tmux"
  tmux list-panes -a -F "#{pane_id} #{pane_current_command}" | while read -r pane cmd; do
    if [[ "$cmd" == "zsh" ]]; then
      echo "Sending to $pane"
      tmux send-keys -t "$pane" "$COMMAND" C-m
    fi
  done
else
  echo "no init term"
fi
