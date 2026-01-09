#!/usr/bin/env bash
set -eo pipefail

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"

toggle_module() {
  local module action pattern
  module="$1" action="$2"
  pattern="^\(\s*\)\"$module\",\s*// - replace"
  case $action in
  start) sed -i "s|^\(\s*\)// \"$module\",\s*// - replace|\1\"$module\", // - replace|" "$CONFIG" ;;
  stop) sed -i "s|$pattern|\1// \"$module\", // - replace|" "$CONFIG" ;;
  *) grep -q "$pattern" "$CONFIG" && toggle_module "$module" stop || toggle_module "$module" start ;;
  esac
}

_kill() { pkill waybar 2>/dev/null || true; }
_start() { _kill && nohup waybar --config "$CONFIG" --style "$STYLE" &>/dev/null & }

module="${1##--}"
case $1 in
--bluetooth | --cava) toggle_module "$module" "$2" && _start ;;
--mpd) sed -i -E "s|^(\s*)\"server\":\s*\".*\",\s*// - replace|\1\"server\": \"$2\", // - replace|" "$CONFIG" && _start ;;
--start) _start ;;
--kill) _kill ;;
esac
