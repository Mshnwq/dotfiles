#!/usr/bin/env bash


unmount_commands() {
  sudo umount /mnt/mshnwq/ubuntu
  ls -la /mnt
  ls -la /mnt/mshnwq/ubuntu
  dfrs
  echo "Unmounted. Press Enter to close..."
  read
}

export -f unmount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm \
  -e bash -c "bash -i -c unmount_commands"
