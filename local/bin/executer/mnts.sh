#!/usr/bin/env bash
set -euo pipefail

MNT_CONF="$HOME/.config/mounts.conf"
ROFI_THEME="$HOME/.config/rofi/SelectorMnt.rasi"
[[ -s $MNT_CONF ]] || exit 1

mapfile -t mnts <"$MNT_CONF"
options=() && mount_points=()
for mnt in "${mnts[@]}"; do
  mount_trim="${mnt% &&*}"        # remove last && cmd
  mount_point="${mount_trim##* }" # gets last word in cmd
  mount_points+=("$mount_point")
  if mountpoint -q "$mount_point" 2>/dev/null; then
    options+=("✓ ${mount_point##*/}")
  else
    options+=("  ${mount_point##*/}")
  fi
done

selected=$(printf '%s\n' "${options[@]}" |
  rofi -dmenu -theme "$ROFI_THEME")
[[ -z $selected ]] && exit 0

for i in "${!options[@]}"; do
  if [[ "${options[$i]}" == "$selected" ]]; then
    mount_point="${mount_points[$i]}"
    mount_cmd="${mnts[$i]}"

    if mountpoint -q "$mount_point" 2>/dev/null; then
      action="Unmounted" && cmd="sudo umount $mount_point; disk"
    else
      action="Mounted" && cmd="$mount_cmd"
    fi

    alacritty --class FloaTerm,DiskTerm --title=DiskTerm \
      -e bash -c "
        export PATH=\"\$HOME/.local/bin:\$PATH\"
        echo '$cmd'; read -p 'Proceed? [Y/n] ' -n 1 -r
        if [[ \$REPLY =~ ^[Yy]$ ]] || [[ -z \$REPLY ]]; then
          $cmd; dunstify \"$action\" \"$mount_point\"; read -r
        fi
      "
    break
  fi
done
