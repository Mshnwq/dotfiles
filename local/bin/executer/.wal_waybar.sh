#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.cache/wal/colors.sh"

sed -i "/\/\/-clock-date/s|\"<span color='#.*'><b>{}</b></span>\"|\"<span color='${cursor}'><b>{}</b></span>\"|" "$HOME/.config/waybar/config.jsonc"
sh -c "$HOME/.local/bin/executer/.waybar_start.sh"
