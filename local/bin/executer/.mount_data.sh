#!/usr/bin/env bash

mount_commands() {
  sudo mount -t ntfs-3g -o uid="$(id -u "$USER")",gid="$(id -g "$USER")" /dev/sda1 /mnt/internal/data
  disk
  echo "Mounted. Press Enter to close..."
  read -r
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -ic mount_commands"
