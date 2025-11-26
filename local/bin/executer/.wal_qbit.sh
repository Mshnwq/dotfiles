#!/usr/bin/env bash

BUILDDIR=$(<"$HOME/.config/builddir")
BUILDDIR="${BUILDDIR/#\~/$HOME}"
cd "$BUILDDIR/qbittorrent" && nix-shell -p libsForQt5.qt5.qtbase --run "just compile"

STATE_FILE="/tmp/qbit_state.json"
WINDOW_CLASS="org.qbittorrent.qBittorrent"

hyprctl clients -j | jq -r --arg class "$WINDOW_CLASS" '
  .[] | select(.class == $class) |
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
  echo "[INFO] qBitTorrent window state saved to $STATE_FILE"
else
  echo "[ERROR] Could not find window with class '$WINDOW_CLASS'."
  if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 1
  else
    exit 1
  fi
fi

#####

# ReLaunch qBitTorrent
pkill -f "qbittorrent"
gtk-launch org.qbittorrent.qBittorrent & disown

# Wait for it to appear
for i in {1..10}; do
  sleep 0.3
  WIN_ID=$(hyprctl clients -j | jq -r --arg class "$WINDOW_CLASS" '.[] | select(.class == $class) | .address')
  if [ -n "$WIN_ID" ]; then
    echo $WIN_ID
    break
  fi
done

if [ -z "$WIN_ID" ]; then
  echo "[ERROR] Failed to relaunch qbittorrent."
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

echo "[INFO] qBitTorrent restored to previous state."
