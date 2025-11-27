#!/usr/bin/env bash

nas_commands() {
  pass mshnwq/home-server | wl-copy
  sudo mount -t cifs //192.168.0.200/NAS /mnt/external/nas \
    -o username=mshnwq,uid=$(id -u),gid=$(id -g),rw,sec=ntlmssp,vers=3.0
  duf --theme ansi --only network
  echo "Mounted. Press Enter to close..."
  read
}

export -f nas_commands
alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c nas_commands"
