#!/usr/bin/env bash

mount_commands() {
  sudo mount -t ntfs-3g -o uid=$(id -u mshnwq),gid=$(id -g mshnwq) /dev/sdc1 /mnt/external/backup
  disk
  echo "Mounted. Press Enter to close..."
  read
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c mount_commands"
