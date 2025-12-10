#!/usr/bin/env bash

if pgrep -f libinput-gestures >/dev/null; then
  if [ "$1" == "--quiet" ]; then
    echo "on"
  else
    notify-send -u low "Gesture status" "On"
  fi
else
  if [ "$1" == "--quiet" ]; then
    echo "off"
  else
    notify-send -u low "Gesture status" "Off"
  fi
fi
