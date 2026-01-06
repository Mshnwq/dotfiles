#!/usr/bin/env bash

CONF_DIR="$HOME/.config/kitty"
CONF="$CONF_DIR/kitty.conf"

opt="${1##--}"
sed -i '/# -- start replace/,/# -- end replace/{
  /# -- start replace/!{/# -- end replace/!d}
}' "$CONF"
sed -i "/-- start replace/r /dev/stdin" "$CONF" < <(tail "$CONF_DIR/kitty-$opt.conf" -n+3)
