#!/bin/bash

nas_commands() {
  echo "Enter SMB password:"
  read -rs SMB_PASS
  echo

  # sudo systemctl start smbd.service
  # sudo systemctl start nmbd.service

  sudo mount -t cifs //192.168.0.200/nas/Shared /mnt/nas \
    -o username=home,password="$SMB_PASS",uid=$(id -u),gid=$(id -g),rw


  ls -la /mnt
  ls -la /mnt/nas
  echo "Mounted. Press Enter to close..."
  read
}

export -f nas_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm -e bash -c "bash -i -c nas_commands"
