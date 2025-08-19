#!/bin/env bash

# Variables
LOCAL_DIR="${HOME}/Music/"
REMOTE_DIR="/home/home/Music/"
REMOTE_HOST_ALIAS="home-server"

# Sync command
rsync -avz --delete "$LOCAL_DIR" "${REMOTE_HOST_ALIAS}:$REMOTE_DIR"

ssh $REMOTE_HOST_ALIAS 'sh /home/home/media/music/scripts/mpc_refresh.sh'
