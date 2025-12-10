#!/usr/bin/env bash

tmux_file="$HOME/.config/tmux/tmux.conf"

SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
if [ -S "$SOCKET_FILE" ]; then
  echo "refreshing tmux"
  tmux source-file "$tmux_file"
  sleep 0.5
  tmux source-file "$tmux_file"
else
  echo "no init term"
fi
