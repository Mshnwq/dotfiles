#!/bin/bash

nas_unmount_commands() {
  echo "Unmounting /mnt/nas..."
  sudo umount /mnt/nas

  echo "Stopping SMB services..."
#  sudo systemctl stop smbd.service
#  sudo systemctl stop nmbd.service

#  pkill tumblerd
#  pkill gvfs
  pkill gvfsd-smb
  # pkill Thunar

  ls -la /mnt
  ls -la /mnt/nas
  echo "Unmounted. Press Enter to close..."
  read
}

export -f nas_unmount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm -e bash -c "bash -i -c nas_unmount_commands"
