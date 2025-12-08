#!/usr/bin/env bash

nas_commands() {
  HOST=$(<"$HOME/.config/mpd_remote_host")
  pass mshnwq/nas-pass | wl-copy
  sudo mount -t cifs "//$HOST/NAS" "/mnt/external/nas" \
    -o username="$USER",uid="$(id -u)",gid="$(id -g)",rw,sec=ntlmssp,vers=3.0
  duf --theme ansi --only network
  echo "Mounted. Press Enter to close..."
  read -r
}

export -f nas_commands
alacritty --option 'font.size=10' \
  --class FloaTerm,DiskTerm --title=DiskTerm \
  -e bash -c "bash -i -c nas_commands"
