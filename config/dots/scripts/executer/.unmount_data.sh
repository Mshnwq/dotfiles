#!/usr/bin/env bash

unmount_commands() {
  sudo umount /mnt/mshnwq/data
  #sleep 1
  #sudo ldmtool remove all
  ls -la /mnt
  ls -la /mnt/mshnwq/data
  duf --theme ansi --only local,fuse --hide-mp /boot/efi
  echo "Unmounted. Press Enter to close..."
  read
}

export -f unmount_commands
alacritty --class FloaTerm,FloaTerm --title=FloaTerm \
  -e bash -c "bash -i -c unmount_commands"
~
