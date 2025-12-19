#!/usr/bin/env bash

rice=$(<"$HOME/.config/dots/.rice")
assets_dir="$HOME/.config/dots/rices/$rice/assets"
sleep 0.2
read -r num_state caps_state < <(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | "\(.numLock) \(.capsLock)"')

_notify() {
  local icon message state
  icon=$1 && message=$2 && state=$3
  dunstify -r 91191 -i "$assets_dir/$icon.svg" "$message" "$state" -u low
}

case $1 in
--num) $num_state && _notify "locked" "Num Lock" "On" || _notify "unlocked" "Num Lock" "Off" ;;
--caps) $caps_state && _notify "locked" "Caps Lock" "On" || _notify "unlocked" "Caps Lock" "Off" ;;
esac

# TODO: find better icons
