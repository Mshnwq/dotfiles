#!/usr/bin/env bash

tmux_file="$HOME/.config/tmux/tmux.conf"
tmux_theme="$HOME/.cache/wal/custom-tmux.sh"

# Delete the old block between the markers
sed -i '/# -- start replace from rice/,/# -- end replace from rice/{
  /# -- start replace from rice/!{/# -- end replace from rice/!d}
}' "$tmux_file"

# Read the theme file into a variable
theme_block="$(<"$tmux_theme")"

# Rewrite the .tmux.zsh file with the new block inserted between the markers
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
' "$tmux_file" > "${tmux_file}.tmp" && mv "${tmux_file}.tmp" "$tmux_file"

SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
if [ -S "$SOCKET_FILE" ]; then
  echo "refreshing tmux"
  tmux source-file $tmux_file
  sleep 0.5
  tmux source-file $tmux_file
else
  echo "no init term"
fi
