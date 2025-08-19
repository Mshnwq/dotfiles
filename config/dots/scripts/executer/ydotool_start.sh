#!/usr/bin/env bash
sudo pkill ydotool 2>/dev/null || true
sudo -b ydotoold --socket-path="$YDOTOOL_SOCKET" --socket-own="$(id -u):$(id -g)"
