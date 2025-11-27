#!/usr/bin/env bash

nas_unmount_commands() {
  echo "Unmounting /mnt/nas..."
  sudo umount /mnt/external/nas
  # pkill gvfs
  # pkill gvfsd-smb
  duf --theme ansi --only network
  disk
  echo "Unmounted. Press Enter to close..."
  read
}

export -f nas_unmount_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c nas_unmount_commands"
