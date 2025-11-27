#!/usr/bin/env bash

mount_commands() {
  #sudo systemctl start smartd.service
  #sleep 2
  #sudo ldmtool create all
  #sleep 1
  #sudo mount -t ntfs-3g -o uid=$(id -u mshnwq),gid=$(id -g mshnwq) /dev/dm-0 /mnt/mshnwq/data
  sudo mount -t ntfs-3g -o uid=$(id -u mshnwq),gid=$(id -g mshnwq) /dev/sda1 /mnt/mshnwq/data
  disk
  echo "Mounted. Press Enter to close..."
  read
}

export -f mount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c mount_commands"
