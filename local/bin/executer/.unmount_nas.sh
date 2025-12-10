#!/usr/bin/env bash

nas_unmount_commands() {
  echo "Unmounting nas..."
  sudo umount /mnt/external/nas
  # pkill gvfs
  # pkill gvfsd-smb
  duf --theme ansi --only network
  disk
  echo "Unmounted. Press Enter to close..."
  read -r
}

export -f nas_unmount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -ic nas_unmount_commands"
