#!/bin/bash
if systemctl is-active --quiet tailscaled.service; then
  if [ "$1" == "--quiet" ]; then
    echo "on"
  else
    notify-send -u low "Tailscale status" "On"
  fi
else
  if [ "$1" == "--quiet" ]; then
    echo "off"
  else
    notify-send -u low "Tailscale status" "Off"
  fi
fi
