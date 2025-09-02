#!/usr/bin/env bash


unmount_commands() {
  sudo umount /mnt/mshnwq/arch
  ls -la /mnt
  ls -la /mnt/mshnwq/arch
  dfrs
  echo "Unmounted. Press Enter to close..."
  read
}

export -f unmount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm \
  -e bash -c "bash -i -c unmount_commands"
