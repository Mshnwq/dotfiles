#!/bin/env bash

STATUS_FILE="$HOME/.config/dots/.mpd_status"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "remote" ]]; then
    echo "Stop Remote MPD First"
    dunstify -u critical "Error" "Stop Remote MPD First"
    exit 1
fi

systemctl --user start mpd.service 
echo "local" > "$STATUS_FILE"

HOST_FILE="$HOME/.config/dots/.mpd_host"
HOST="127.0.0.1"
echo "$HOST" > "$HOST_FILE"
