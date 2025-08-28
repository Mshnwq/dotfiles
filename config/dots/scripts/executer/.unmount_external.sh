#!/usr/bin/env bash

unmount_commands() {
  sudo umount /mnt/external
  ls -la /mnt
  ls -la /mnt/external
  echo "Unmounted. Press Enter to close..."
  read
}

export -f unmount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm \
  -e bash -c "bash -i -c unmount_commands"
~
