#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/.wal_lib.sh" || exit 1
wal:relaunch \
  --kind title \
  --window-filter "FileTerm" \
  --launch-cmd "OpenApps --yazi-tmux-last" \
  --kill-cmd "YAZI_ID=\"$(<"$HOME/.config/dots/.yazi_id")\" ya emit plugin projects quit && tmux kill-session -t yazi"
