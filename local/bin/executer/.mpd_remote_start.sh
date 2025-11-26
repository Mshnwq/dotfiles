#!/usr/bin/env bash

STATUS_FILE="$HOME/.config/dots/.mpd_status"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "local" ]]; then
    echo "Stop Local MPD First"
    dunstify -u critical "Error" "Stop Local MPD First"
    exit 1
fi

HOST=$(<"$HOME/.config/mpd_remote_host")
CONF_FILE="$HOME/.config/pipewire/pipewire-pulse.conf.d/mpd-tcp.conf"
mkdir -p "$(dirname "$CONF_FILE")"
cat > "$CONF_FILE" <<EOF
pulse.cmd = [
  { cmd = "load-module" args = "module-native-protocol-tcp auth-ip-acl=$HOST auth-anonymous=1" }
]
EOF
#sudo ufw allow from $HOST to any port 4713 proto tcp
sudo firewall-cmd --zone=public --add-rich-rule="rule family='ipv4' source address='$HOST' port protocol='tcp' port='4713' accept"
systemctl --user restart pipewire-pulse
echo "remote" > "$STATUS_FILE"
HOST_FILE="$HOME/.config/dots/.mpd_host"
echo "$HOST" > "$HOST_FILE"
