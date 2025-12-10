#!/usr/bin/env bash

notify-send "Pass Pin Entry" "Selecting Pass Pin Entry Program"

ROFI_THEME="$HOME/.config/rofi/SelectorPin.rasi"
BIN_DIRS=("$HOME/.local/bin" "$XDG_STATE_HOME/nix/profile/bin" "$HOME/.nix-profile/bin" "/usr/bin")
export PATH="$HOME/.local/bin:$PATH"

# Collect all pinentry binaries from BIN_DIRS
mapfile -t options < <(
  for dir in "${BIN_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    ls -1 "$dir" | grep 'pinentry-' | sed "s|pinentry-||"
  done | sort -u
)

# Check if any pinentry options are found
if [[ ${#options[@]} -eq 0 ]]; then
  notify-send "Pass Pin Entry" "No pinentry programs found."
  exit 1
fi

# Show Rofi menu and get the user's choice
CHOICE=$(printf '%s\n' "${options[@]}" | rofi -theme "$ROFI_THEME" -mesg "[ Select Pass Pin Entry Program ]" -dmenu)

# If user pressed Escape or didn't select anything
if [[ -z "$CHOICE" ]]; then
  notify-send "Pass Pin Entry" "No pinentry program selected."
  exit 0
fi

# Update gpg-agent.conf
GPG_CONF="$GNUPGHOME/gpg-agent.conf"
echo "pinentry-program $(command -v "pinentry-$CHOICE")" >"$GPG_CONF"

# Reload gpg-agent
gpg-connect-agent reloadagent /bye

# Confirm selection
notify-send "Pass Pin Entry" "Set pinentry program to: pinentry-$CHOICE"
