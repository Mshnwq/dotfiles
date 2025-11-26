#!/usr/bin/env bash

# sudo ufw allow from 192.168.0.0/24 to any port 6600
sudo ufw allow 67
sudo ufw allow 53
sudo ufw default allow FORWARD
sudo systemctl start waydroid-container.service
sudo waydroid container start
weston --xwayland &
WESTON_PID=$!
export WAYLAND_DISPLAY=wayland-1
sleep 2

waydroid show-full-ui &
WAYDROID_PID=$!

trap "waydroid session stop; kill $WESTON_PID; kill $WAYDROID_PID" EXIT

wait $WESTON_PID
