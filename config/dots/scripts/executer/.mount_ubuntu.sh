#!/usr/bin/env bash

mount_commands() {
  sudo mount -o ro /dev/sdb5 /mnt/mshnwq/ubuntu
  ls -la /mnt
  ls -la /mnt/mshnwq/ubuntu
  dfrs
  echo "Mounted. Press Enter to close..."
  read
}

export -f mount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm \
  -e bash -c "bash -i -c mount_commands"
~
