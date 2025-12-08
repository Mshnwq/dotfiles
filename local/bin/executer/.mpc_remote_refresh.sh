#!/usr/bin/env bash

# Variables
LOCAL_DIR="$HOME/Music/"
REMOTE_DIR="/var/lib/mpd/music"
REMOTE_HOST_ALIAS="home-server"

# Sync command
rsync -avz --delete "$LOCAL_DIR" "${REMOTE_HOST_ALIAS}:$REMOTE_DIR"

ssh $REMOTE_HOST_ALIAS 'mpc_refresh.sh'
