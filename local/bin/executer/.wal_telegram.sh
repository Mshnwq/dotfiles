#!/usr/bin/env bash

# https://legacy.imagemagick.org/Usage/blur/#blur_args.
wal-telegram --wal -d "$HOME/.cache/wal" -g 1x1

source "${BASH_SOURCE%/*}/.wal_lib.sh" || exit 1
wal:relaunch \
  --kind class \
  --kill-cmd "pkill -f Telegram" \
  --window-filter "org.telegram.desktop" \
  --launch-cmd "flatpak run org.telegram.desktop"
