#!/usr/bin/env bash
set -euo pipefail

_start() { { _kill "$1"; } && sleep 0.5; }
_kill() { pkill -f "$1" --older 1 &>/dev/null || true; }
_status() { dunstify -u low "${1^} Status" "$(pgrep -f "$app" --older 1 &>/dev/null && echo "On" || echo "Off")"; }

actions=(
  "kill"
  "start"
  "status"
)

(($# == 0)) || [[ ! $2 =~ ^($(printf '%s|' "${actions[@]}"))$ ]] && exit 2
app="${1##--}" && action="$2"

case $1 in
--dunst)
  { "_$action" "$app"; }
  [[ $action == "${actions[1]}" ]] && {
    CONF="$HOME/.config/dunst/dunstrc"
    [[ -s $CONF ]] && nohup "$app" \
      -config "$CONF" &>/dev/null &
  }
  ;;
--gesture)
  app="libinput-gestures"
  { "_$action" "$app"; }
  [[ $action == "${actions[1]}" ]] && {
    CONF="$HOME/.config/libinput-gestures.conf"
    [[ -s $CONF ]] && "$app" --conffile "$CONF" &>/dev/null &
  }
  ;;
--ydotoold)
  { "_$action" "$app"; }
  [[ $action == "${actions[1]}" ]] && {
    [[ -n $YDOTOOL_SOCKET ]] && sudo \
      --background "$app" \
      --socket-path="$YDOTOOL_SOCKET" \
      --socket-own="$(id -u):$(id -g)" &>/dev/null &
  }
  ;;
--kmonad)
  { "_$action" config.kbd; }
  [[ $action == "${actions[1]}" ]] && {
    CONF="$HOME/.config/kmonad/config.kbd"
    [[ -s $CONF ]] && "$app" "$CONF" &>/dev/null &
  }
  ;;
esac
