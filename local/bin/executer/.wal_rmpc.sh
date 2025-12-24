#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/.wal_lib.sh" || exit 1
wal:relaunch \
  --kind title \
  --kill-cmd "pkill rmpc" \
  --window-filter "MusicTerm" \
  --launch-cmd "OpenApps --music"
