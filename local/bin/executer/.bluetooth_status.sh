#!/usr/bin/env bash

if [[ ! -d /sys/class/bluetooth ]]; then
  echo "No Bluetooth interface"
  exit 0
fi

# Colors
FILE="$HOME/.cache/wal/colors-rio.toml"
POWER_ON=$(awk '/^blue =/ {print $3; exit}' "$FILE")
POWER_OFF=$(awk '/^cursor =/ {print $3; exit}' "$FILE")

check_bluetooth() {
  if systemctl is-active --quiet bluetooth.service; then
    notify-send -u low "Bluetooth status" "On"
    if bluetoothctl show | grep -q "Powered: yes"; then
      echo "%{F$POWER_ON}󰂯%{F-}" # Bluetooth is on
    else
      echo "%{F$POWER_OFF}󰂲%{F-}" # Bluetooth is off
    fi
  else
    notify-send -u low "Bluetooth status" "Off"
    echo
  fi
}

check_bluetooth
