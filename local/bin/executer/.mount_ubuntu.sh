#!/usr/bin/env bash

mount_commands() {
  sudo mount -o ro /dev/sdb5 /mnt/mshnwq/ubuntu
  disk
  echo "Mounted. Press Enter to close..."
  read
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c mount_commands"
