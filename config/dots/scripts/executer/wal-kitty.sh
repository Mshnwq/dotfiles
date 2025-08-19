#!/usr/bin/env bash

for socket in "$XDG_RUNTIME_DIR"/kitty_socket-*; do
  kitten @ --to unix:"$socket" load-config "$XDG_CONFIG_HOME/kitty/kitty.conf"
done

# also implement one for init-term tmux
SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
if [ -S "$SOCKET_FILE" ]; then
  echo "refreshing tmux"
  kitten @ --to unix:"$SOCKET_FILE" load-config "$XDG_CONFIG_HOME/kitty/kitty.conf"
else
  echo "no init term"
fi
