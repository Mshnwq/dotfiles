#!/usr/bin/env bash

unmount_commands() {
  sudo umount /mnt/mshnwq/data
  #sleep 1
  #sudo ldmtool remove all
  disk
  echo "Unmounted. Press Enter to close..."
  read
}

export -f unmount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c unmount_commands"
