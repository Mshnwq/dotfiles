#!/bin/env bash

CONF_FILE="$HOME/.config/mpv/mpv.conf"
cat > "$CONF_FILE" <<EOF
osd-level=0
title='\${filename}'
vo=gpu-next
hwdec=d3d11va
gpu-api=d3d11
EOF
