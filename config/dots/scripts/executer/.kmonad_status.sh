#!/usr/bin/env bash
if pgrep -f config.kbd > /dev/null; then
  if [ "$1" == "--quiet" ]; then
    echo "on"
  else
    notify-send -u low "Kmonad status" "On"
  fi
else
  if [ "$1" == "--quiet" ]; then
    echo "off"
  else
    notify-send -u low "Kmonad status" "Off"
  fi
fi

