#!/usr/bin/env bash

LOCAL_DIR="$HOME/Music/"

case $1 in
--local-ref)
  cd "$LOCAL_DIR" || exit 1
  mpc clear && mpc update && sleep 2
  find . -type f -name '*.m4a' | sed 's|^\./||' | while read -r song; do
    mpc add "$song"
  done
  ;;
--remote-ref)
  REMOTE_DIR="/var/lib/mpd/music"
  REMOTE_HOST_ALIAS="home-server"
  rsync -avz --delete "$LOCAL_DIR" "${REMOTE_HOST_ALIAS}:$REMOTE_DIR"
  ssh $REMOTE_HOST_ALIAS 'mpc_refresh.sh'
  ;;
esac
