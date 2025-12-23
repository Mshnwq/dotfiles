#!/usr/bin/env bash

CONF="$HOME/.config/hypr/conf.d/general.conf"

if [[ $1 == "--on" ]]; then
  sed -i "$CONF" \
    -e "/#-toggle-blur/s/.*#-/	enabled = true \t#-/" \
    -e "/#-toggle-animation/s/.*#-/    enabled = true \t#-/" \
    -e "/#-toggle-ws-animation/s/.*#-/    workspace_wraparound = true \t#-/" \
    -e "/^#windowrule = opacity 0.8 override 1 override 1 override, class:firefox.*/ s/^#//"
else
  sed -i "$CONF" \
    -e "/#-toggle-blur/s/.*#-/	enabled = false \t#-/" \
    -e "/#-toggle-animation/s/.*#-/    enabled = false \t#-/" \
    -e "/#-toggle-ws-animation/s/.*#-/    workspace_wraparound = false \t#-/" \
    -e "/^windowrule = opacity 0.8 override 1 override 1 override, class:firefox.*/ s/^/#/"
fi
