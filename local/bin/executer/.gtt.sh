#!/usr/bin/env bash
set -euo pipefail

TITLE="TranTerm"
DATA_DIR="$HOME/Documents/GTT"
[[ -d $DATA_DIR ]] || mkdir -p "$DATA_DIR"

is_gtt() {
  local wid
  wid=$(hyprctl clients -j | jq -r --arg title "$TITLE" '
    .[] | select(.title | contains($title)) | .workspace.id' | head -n1)
  [[ -n $wid ]] && {
    hyprctl dispatch workspace "$wid"
    hyprctl dispatch focuswindow "title:$TITLE"
    return 0
  }
  return 1
}

# TODO: when have langauge set menu then have that info also
extract_gtt() {
  local src dst date_file
  ydotool key 97:1 34:1 97:0 34:0
  sleep 0.1 && src=$(wl-paste)
  ydotool key 97:1 19:1 97:0 19:0
  sleep 0.1 && dst=$(wl-paste)
  date_file="$DATA_DIR/$(date '+%Y-%m-%d').md"
  [[ ! -f $date_file ]] &&
    echo "| Source | Translation |" >"$date_file" &&
    echo "|--------|-------------|" >>"$date_file"
  echo "| $src | $dst |" >>"$date_file"
  echo "Saved to: $date_file"
}

if is_gtt; then
  extract_gtt
  dunstify "GTT: Extracted"
else
  dunstify "GTT: Not Active"
fi
