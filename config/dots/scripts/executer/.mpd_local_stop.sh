#!/usr/bin/env bash

MediaControl --stop
systemctl --user stop mpd.service 

STATUS_FILE="$HOME/.config/dots/.mpd_status"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "local" ]]; then
    echo "Remote flag found — clearing..."
    > "$STATUS_FILE"
else
    echo "No remote flag found."
fi
