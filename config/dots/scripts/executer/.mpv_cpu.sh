#!/bin/env bash

CONF_FILE="$HOME/.config/mpv/mpv.conf"
cat > "$CONF_FILE" <<EOF
osd-level=0
title='\${filename}'
EOF
