#!/usr/bin/env bash

CONF="$HOME/.config/alacritty/alacritty.toml"

if [[ $1 == "--on" ]]; then
  sed -i "s/opacity = .*/opacity = 0.50/" "$CONF"
else
  sed -i "s/opacity = .*/opacity = 1/" "$CONF"
fi
