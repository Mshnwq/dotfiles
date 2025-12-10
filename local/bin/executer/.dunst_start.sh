#!/usr/bin/env bash

pkill dunst 2>/dev/null || true
nohup dunst -config "$HOME/.config/dunst/dunstrc" >/dev/null 2>&1 &
