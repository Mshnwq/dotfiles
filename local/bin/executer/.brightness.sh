#!/usr/bin/env bash
set -euo pipefail

MAX=$(brightnessctl max)
current=$(brightnessctl get)
rice=$(<"$HOME/.config/dots/.rice")
assets_dir="$HOME/.config/dots/rices/$rice/assets"

brightness() {
  local direction value
  direction=$1 && value=$2
  if [[ $direction == "up" ]]; then
    [[ $current == "$MAX" ]] || brightnessctl -e4 -n2 set "$value%+"
  else
    [[ current -lt "300" ]] || brightnessctl -e4 -n2 set "$value%-"
  fi
  new_current=$(brightnessctl get -P)
  dunstify -p -a "brightness" \
    -r 12345 -h int:value:"$new_current" \
    "$new_current%" --icon="$assets_dir/brightness.png"
}

(($# > 0)) || exit 1
value=${2:-5} && ((value > 0)) || exit 1

case $1 in
--up) brightness up $((value)) ;;
--down) brightness down $((value)) ;;
--help) echo "Usage: ${0##*/} --up|--down percentage" ;;
*) $0 --help >&2 && exit 1 ;;
esac
