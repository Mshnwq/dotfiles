#!/usr/bin/env bash

mount_commands() {
  sudo mount -o ro /dev/sdb5 /mnt/internal/ubuntu
  disk
  echo "Mounted. Press Enter to close..."
  read -r
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c mount_commands"
