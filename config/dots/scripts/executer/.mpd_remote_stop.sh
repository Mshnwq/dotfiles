#!/bin/env bash

HOST="192.168.0.200"
MediaControl --stop
sudo ufw delete allow from $HOST to any port 4713 proto tcp
CONF_FILE="$HOME/.config/pipewire/pipewire-pulse.conf.d/mpd-tcp.conf"
rm -f "$CONF_FILE"
systemctl --user restart pipewire-pulse
$HOME/.config/dots/scripts/executer/waybar_mpd.sh

STATUS_FILE="$HOME/.config/dots/.mpd_status"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "remote" ]]; then
    echo "Remote flag found — clearing..."
    > "$STATUS_FILE"
else
    echo "No remote flag found."
fi
HOST_FILE="$HOME/.config/dots/.mpd_host"
> "$HOST_FILE"
