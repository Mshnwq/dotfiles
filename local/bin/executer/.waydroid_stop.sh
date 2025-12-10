#!/usr/bin/env bash

waydroid session stop
sudo waydroid container stop
sudo ufw delete allow 53
sudo ufw delete allow 67
sudo ufw default deny forward
sudo systemctl stop waydroid-container.service
pkill weston
pkill waydroid
