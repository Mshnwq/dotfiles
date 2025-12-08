#!/usr/bin/env bash

mount_commands() {
  sudo mount -t ntfs-3g -o uid="$(id -u $USER)",gid="$(id -g $USER)" /dev/sdc1 /mnt/external/backup
  disk
  echo "Mounted. Press Enter to close..."
  read -r
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c mount_commands"
