#!/usr/bin/env bash

# Build qBittorrent first
BUILDDIR=$(<"$HOME/.config/builddir")
BUILDDIR="${BUILDDIR/#\~/$HOME}"
cd "$BUILDDIR/qbittorrent" && nix-shell -p libsForQt5.qt5.qtbase --run "just compile"
cd - || exit 1

source "${BASH_SOURCE%/*}/.wal_lib.sh" || exit 1
wal:relaunch \
  --kind class \
  --kill-cmd "pkill -f qbittorrent" \
  --window-filter "org.qbittorrent.qBittorrent" \
  --launch-cmd "gtk-launch org.qbittorrent.qBittorrent"
