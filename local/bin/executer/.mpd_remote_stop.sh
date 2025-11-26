#!/usr/bin/env bash

HOST=$(<"$HOME/.config/mpd_remote_host")

MediaControl --stop
# sudo ufw delete allow from $HOST to any port 4713 proto tcp
sudo firewall-cmd --zone=public --remove-rich-rule="rule family='ipv4' source address='$HOST' port protocol='tcp' port='4713' accept"
CONF_FILE="$HOME/.config/pipewire/pipewire-pulse.conf.d/mpd-tcp.conf"
rm -f "$CONF_FILE"
systemctl --user restart pipewire-pulse

STATUS_FILE="$HOME/.config/dots/.mpd_status"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "remote" ]]; then
    echo "Remote flag found — clearing..."
    > "$STATUS_FILE"
else
    echo "No remote flag found."
fi
HOST_FILE="$HOME/.config/dots/.mpd_host"
> "$HOST_FILE"
