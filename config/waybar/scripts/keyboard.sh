#!/usr/bin/env bash

# Get JSON block for main keyboard
keyboard=$(hyprctl devices -j | jq '.keyboards[] | select(.main == true)')

# Extract fields
layout=$(echo "$keyboard" | jq -r '.active_keymap')
caps=$(echo "$keyboard" | jq -r '.capsLock')
num=$(echo "$keyboard" | jq -r '.numLock')

# Normalize layout to 2-letter code
case "$layout" in
  *"English (US)"*) short="EN" ;;
  *"Arabic"*)       short="AR" ;;
  *"Russian"*)      short="RU" ;;
  *)                short="??" ;;
esac

# Pretty labels for states
caps_status=$( [[ "$caps" == "true" ]] && echo "On" || echo "Off" )
num_status=$( [[ "$num" == "true" ]] && echo "On" || echo "Off" )

# Output JSON for Waybar
echo "{\"text\": \"$short\", \"tooltip\": \"$layout\nCaps Lock: $caps_status\nNum Lock: $num_status\"}"
#echo "{\"text\": \"󰌌 $short\", \"tooltip\": \"$layout\nCaps Lock: $caps_status\nNum Lock: $num_status\"}"
