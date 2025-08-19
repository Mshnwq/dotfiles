#!/bin/env bash

STATUS=$(cat "$HOME/.config/dots/.mpd_status")
if [[ -n $STATUS ]]; then
  if [ "$1" == "--quiet" ]; then
    echo "on"
  else
    notify-send -u low "MPC status" "On $STATUS"
  fi
else
  if [ "$1" == "--quiet" ]; then
    echo "off"
  else
    notify-send -u low "MPC status" "Off"
  fi
fi
