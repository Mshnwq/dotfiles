#!/bin/env bash

file="$HOME/.config/kitty/theme.conf"

current=$(grep -oP 'background_opacity\s+\K[0-9.]+' "$file")
new=$(awk -v val="$current" 'BEGIN { val+=0.05; if(val > 1) val=1; printf "%.2f", val }')

sed -i "s/\(background_opacity\s\+\).*/\1$new/" "$file"

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
