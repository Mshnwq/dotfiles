#!/usr/bin/env bash

export PATH="$HOME/.config/dots/scripts:$PATH"

CFG_MPD="$HOME/.config/dots/.mpd_status"
MY_MPD=$(<"$CFG_MPD")
REMOTE_MPD="$HOME/.config/dots/.mpd_host"
MPD_REMOTE=$(<"$REMOTE_MPD")

# Define an mpc wrapper that injects host and port
mpc_cmd() {
  case "$MY_MPD" in
    "remote")
      MPD_HOST="$MPD_REMOTE"
      MPD_PORT="6600"
      ;;
    "local")
      MPD_HOST="127.0.0.1"
      MPD_PORT="6600"
      ;;
    *)
      MPD_HOST="localhost"
      MPD_PORT="6600"
      ;;
  esac
  mpc --host "$MPD_HOST" --port "$MPD_PORT" "$@"
}

LAST_TITLE=""
while mpc_cmd idle player >/dev/null; do
  TITLE=$(MediaControl --title)
  if [ "$TITLE" == "Play Something" ]; then
    continue
  fi
  if [ "$TITLE" != "$LAST_TITLE" ]; then
    # Skip if rmpc is running
    if pgrep -x rmpc >/dev/null; then
      continue
    fi
    MediaControl --notify
    LAST_TITLE="$TITLE"
  fi
done
