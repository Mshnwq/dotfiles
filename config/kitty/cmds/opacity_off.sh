#!/bin/env bash

sed -i "s/background_opacity .*/background_opacity 1/" "$HOME/.config/kitty/theme.conf"

for socket in "$XDG_RUNTIME_DIR"/kitty_socket-*; do
  kitten @ --to unix:"$socket" load-config "$HOME/.config/kitty/kitty.conf"
done

# also implement one for init-term tmux
SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
if [ -S "$SOCKET_FILE" ]; then
  echo "refreshing tmux"
  kitten @ --to unix:"$SOCKET_FILE" load-config "$HOME/.config/kitty/kitty.conf"
else
  echo "no init term"
fi
