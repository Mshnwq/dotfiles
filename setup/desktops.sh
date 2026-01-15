#!/usr/bin/env bash

# File containing list of desktop filenames to hide (one per line)
LIST_FILE="$1"

# Verify input
if [[ -z $LIST_FILE || ! -f $LIST_FILE ]]; then
  echo "Usage: $0 list_of_apps.txt"
  echo "Each line in list_of_apps.txt should match a .desktop filename (e.g., firefox.desktop)"
  exit 1
fi

# Directories to search for desktop files
SEARCH_DIRS=(
  "/usr/share/applications"
  "/lib/flatpak/exports/share/applications"
  "/var/lib/flatpak/app/org.virt_manager.virt-manager/current/active/export/share/applications"
  "$HOME/.local/state/nix/profile/share/applications"
  "$HOME/.local/share/applications" # waydroid
)

# Ensure target directory exists
mkdir -p "$HOME/.local/share/applications"

while IFS= read -r entry; do
  [[ -z $entry ]] && continue
  entry="$entry.desktop"
  echo "Hiding $entry ..."

  # Find first match in SEARCH_DIRS
  for dir in "${SEARCH_DIRS[@]}"; do
    src="$dir/$entry"
    [[ -f $src ]] && {
      dest="$HOME/.local/share/applications/$entry"
      cp "$src" "$dest"
      sudo chmod 666 "$dest"
      # Add Hidden=true (or replace if already set)
      if grep -q 'Hidden=' "$dest"; then
        sed -i 's/^Hidden=.*/Hidden=true/' "$dest"
      else
        sed -i '4iHidden=true' "$dest"
      fi
      echo " -> Copied and marked hidden: $dest"
      break
    }
  done
done <"$LIST_FILE"
