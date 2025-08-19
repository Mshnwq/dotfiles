#!/usr/bin/env bash

CONFIG="${HOME}/.config/waybar/config.jsonc"  # Adjust path if needed

# Functions
enable_cava() {
  sed -i 's|^\(\s*\)// "cava",\s*// - replace|\1"cava", // - replace|' "$CONFIG"
  echo "Cava module enabled."
}

disable_cava() {
  sed -i 's|^\(\s*\)"cava",\s*// - replace|\1// "cava", // - replace|' "$CONFIG"
  echo "Cava module disabled."
}

toggle_cava() {
  if grep -q '^\s*"cava",\s*// - replace' "$CONFIG"; then
    disable_cava
  else
    enable_cava
  fi
}

# Main logic
case "$1" in
  on)
    enable_cava
    ;;
  off)
    disable_cava
    ;;
  toggle|"")
    toggle_cava
    ;;
  *)
    echo "Usage: $0 [on|off|toggle]"
    exit 1
    ;;
esac

pkill waybar 2>/dev/null || true
nohup waybar --config "$HOME/.config/waybar/config.jsonc" --style "$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
