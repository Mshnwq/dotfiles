#!/usr/bin/env bash

CONFIG="${HOME}/.config/waybar/config.jsonc"  # Adjust path if needed

# Functions
enable_bluetooth() {
  sed -i 's|^\(\s*\)// "bluetooth",\s*// - replace|\1"bluetooth", // - replace|' "$CONFIG"
  echo "Cava module enabled."
}

disable_bluetooth() {
  sed -i 's|^\(\s*\)"bluetooth",\s*// - replace|\1// "bluetooth", // - replace|' "$CONFIG"
  echo "Cava module disabled."
}

toggle_bluetooth() {
  if grep -q '^\s*"bluetooth",\s*// - replace' "$CONFIG"; then
    disable_bluetooth
  else
    enable_bluetooth
  fi
}

# Main logic
case "$1" in
  on)
    enable_bluetooth
    ;;
  off)
    disable_bluetooth
    ;;
  toggle|"")
    toggle_bluetooth
    ;;
  *)
    echo "Usage: $0 [on|off|toggle]"
    exit 1
    ;;
esac

pkill waybar 2>/dev/null || true
nohup waybar --config "$HOME/.config/waybar/config.jsonc" --style "$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
