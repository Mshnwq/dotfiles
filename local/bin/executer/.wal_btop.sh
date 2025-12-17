#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/.wal_lib.sh"
wal:relaunch \
  --kind title \
  --kill-cmd "pkill btop" \
  --window-filter "TopTerm" \
  --launch-cmd "OpenApps --top"
