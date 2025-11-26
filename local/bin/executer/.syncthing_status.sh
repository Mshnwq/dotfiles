#!/usr/bin/env bash
if systemctl --user is-active --quiet syncthing.service; then
  if [ "$1" == "--quiet" ]; then
    echo "on"
  else
    notify-send -u low "Syncthing status" "On"
  fi
else
  if [ "$1" == "--quiet" ]; then
    echo "off"
  else
    notify-send -u low "Syncthing status" "Off"
  fi
fi
