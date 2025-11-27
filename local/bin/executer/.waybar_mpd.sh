#!/usr/bin/env bash

CONFIG="${HOME}/.config/waybar/config.jsonc"

sed -i -E 's|^(\s*)"server":\s*".*",\s*// - replace|\1"server": "'$1'", // - replace|' "$CONFIG"

pkill waybar 2>/dev/null || true
nohup waybar --config "$HOME/.config/waybar/config.jsonc" --style "$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
