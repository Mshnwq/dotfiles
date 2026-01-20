#!/usr/bin/env bash

CONF="$HOME/.config/kitty/kitty.conf"
THEME="$HOME/.config/kitty/theme.conf"

case $1 in
--on) sed -i "s/background_opacity .*/background_opacity 0.6/" "$THEME" ;;
--off) sed -i "s/background_opacity .*/background_opacity 1/" "$THEME" ;;
--dec)
  current=$(grep -oP 'background_opacity\s+\K[0-9.]+' "$THEME")
  new=$(awk -v val="$current" 'BEGIN { val-=0.05; if(val < 0.05) val=0.05; printf "%.2f", val }')
  sed -i "s/\(background_opacity\s\+\).*/\1$new/" "$THEME"
  ;;
--inc)
  current=$(grep -oP 'background_opacity\s+\K[0-9.]+' "$THEME")
  new=$(awk -v val="$current" 'BEGIN { val+=0.05; if(val > 1) val=1; printf "%.2f", val }')
  sed -i "s/\(background_opacity\s\+\).*/\1$new/" "$THEME"
  ;;
*) exit 1 ;;
esac

for socket in "$XDG_RUNTIME_DIR"/kitty_socket-*; do
  kitten @ --to unix:"$socket" load-config "$CONF"
done

SOCKET_FILE="$XDG_RUNTIME_DIR/init-term-kitty.sock"
[[ -S $SOCKET_FILE ]] && kitten @ --to unix:"$SOCKET_FILE" load-config "$CONF"
