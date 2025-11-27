#!/usr/bin/env bash

STATE_FILE="$XDG_RUNTIME_DIR/fileterm_state.json"
WINDOW_TITLE="FileTerm"

hyprctl clients -j | jq -r --arg title "$WINDOW_TITLE" '
  .[] | select(.title == $title) |
  {
    address: .address,
    class: .class,
    title: .title,
    workspace: .workspace.id,
    monitor: .monitor,
    floating: .floating,
    at: .at,
    size: .size
  }
' >"$STATE_FILE"

if [ -s "$STATE_FILE" ]; then
  echo "[INFO] FileTerm window state saved to $STATE_FILE"
else
  echo "[ERROR] Could not find window with title '$WINDOW_TITLE'."
  if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 1
  else
    exit 1
  fi
fi

#####

# Save
export YAZI_ID="$(<$HOME/.config/dots/.yazi_id)"
ya emit plugin projects quit
tmux kill-session -t yazi
# Resurrect
Term --override-term kitty --yazi-tmux-last &
disown

# Wait for it to appear
for i in {1..10}; do
  sleep 0.3
  WIN_ID=$(hyprctl clients -j | jq -r --arg title "$WINDOW_TITLE" '.[] | select(.title == $title) | .address')
  if [ -n "$WIN_ID" ]; then
    echo $WIN_ID
    break
  fi
done

if [ -z "$WIN_ID" ]; then
  echo "[ERROR] Failed to relaunch FileTerm."
  if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 1
  else
    exit 1
  fi
fi

# Position
readarray -t at < <(jq -r '.at[]' "$STATE_FILE")
readarray -t size < <(jq -r '.size[]' "$STATE_FILE")
workspace=$(jq -r '.workspace' "$STATE_FILE")
floating=$(jq -r '.floating' "$STATE_FILE")

# Apply saved state
[ "$floating" = "false" ] && hyprctl dispatch togglefloating address:$WIN_ID
hyprctl dispatch focuswindow address:$WIN_ID
hyprctl dispatch movetoworkspacesilent "$workspace"
hyprctl dispatch resizewindowpixel "exact ${size[0]} ${size[1]}", address:$WIN_ID
hyprctl dispatch movewindowpixel "exact ${at[0]} ${at[1]}", address:$WIN_ID

echo "[INFO] FileTerm restored to previous state."
