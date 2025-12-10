#!/usr/bin/env bash

# TODO: 

set -euo pipefail

# Configure firewall
# sudo ufw allow 67
# sudo ufw allow 53
# sudo ufw default allow FORWARD

# Start Waydroid services
sudo systemctl start waydroid-container.service
sudo waydroid container start

# Launch Weston with XWayland
weston --xwayland &
WESTON_PID=$!

# Set Wayland display
export WAYLAND_DISPLAY=wayland-1

# Wait for Weston to initialize
sleep 2

# Launch Waydroid UI
waydroid show-full-ui &
WAYDROID_PID=$!

# Cleanup function
cleanup() {
  echo "Cleaning up..."
  waydroid session stop || true
  kill "$WESTON_PID" 2>/dev/null || true
  kill "$WAYDROID_PID" 2>/dev/null || true
}

# Set trap with single quotes to prevent early expansion
trap cleanup EXIT

# Wait for Weston to exit
wait "$WESTON_PID"
