#!/usr/bin/env bash
set -euo pipefail

# Get JSON block for main keyboard
keyboard=$(hyprctl devices -j | jq -c '.keyboards[] | select(.main == true)')

# Exit if no main keyboard found
[[ -n $keyboard ]] || {
  echo "Error: No main keyboard found"
  exit 1
}

# Extract details
IFS=$'\t' read -r layouts_csv layout index caps num < <(
  jq -r '[.layout, .active_keymap, .active_layout_index, .capsLock, .numLock] | @tsv' <<<"$keyboard"
)
IFS=',' read -ra layout_list <<<"$layouts_csv"

# capitlize
short="${layout_list[$index]:0:2}" # limit 2
declare -A locks=(
  [true]="On"
  [false]="Off"
)

# Output JSON for Waybar
printf '{ "text": "%s", "tooltip": "%s" }\n' \
  "${short^^}" "${layout}\nCaps Lock: ${locks[$caps]}\nNum Lock: ${locks[$num]}"
