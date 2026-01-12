#!/usr/bin/env bash
set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/SelectorPin.rasi"

case $1 in
--pinentry)
  BIN_DIRS=(
    "$XDG_STATE_HOME/nix/profile/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
    "/usr/bin"
  )

  notify-send "Pass Pin Entry" "Selecting Pass Pin Entry Program"
  shopt -s nullglob
  mapfile -t options < <(
    for dir in "${BIN_DIRS[@]}"; do
      [[ -d "$dir" ]] || continue
      for file in "$dir"/pinentry-*; do
        echo "${file#*/pinentry-}"
      done
    done | sort -u
  )
  ((${#options[@]} == 0)) && {
    notify-send "Pass Pin Entry" "No pinentry programs found."
    exit 1
  }

  rofi_menu() {
    printf '%s\n' "${options[@]}" | rofi \
      -mesg "[ Select Pass Pin Entry Program ]" \
      -theme "$ROFI_THEME" -dmenu
  }

  choice=$(rofi_menu)
  [[ -z $choice ]] && {
    notify-send "Pass Pin Entry" "No pinentry program selected."
    exit 0
  }

  # Update gpg-agent.conf
  echo "pinentry-program $(command -v "pinentry-$choice")" >"$GNUPGHOME/gpg-agent.conf"
  gpg-connect-agent reloadagent /bye
  notify-send "Pass Pin Entry" "Set pinentry program to: pinentry-$choice"
  ;;
*) echo "Error: Invalid option $1" >&2 && exit 2 ;;
esac
