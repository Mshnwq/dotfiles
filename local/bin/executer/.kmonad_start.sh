#!/usr/bin/env bash

pgrep -f config.kbd || { kmonad "$HOME/.config/kmonad/config.kbd" & }
notify-send -u low "Kmonad status" "On"
