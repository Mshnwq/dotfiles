#!/usr/bin/env bash

# File containing list of desktop filenames to hide (one per line)
LIST_FILE="$1"

# Verify input
if [ -z "$LIST_FILE" ] || [ ! -f "$LIST_FILE" ]; then
  echo "Usage: $0 list_of_apps.txt"
  echo "Each line in list_of_apps.txt should match a .desktop filename (e.g., firefox.desktop)"
  exit 1
fi

# Directories to search for desktop files
SEARCH_DIRS=(
  "$HOME/.local/share/applications"
  "/usr/share/applications"
  # flatpak dont make sense to hide any
)

# Ensure target directory exists
mkdir -p "$HOME/.local/share/applications"

while IFS= read -r entry; do
  [ -z "$entry" ] && continue # skip empty lines
  entry="$entry.desktop"
  echo "Hiding $entry ..."

  # Find first match in SEARCH_DIRS
  for dir in "${SEARCH_DIRS[@]}"; do
    src="$dir/$entry"
    if [ -f "$src" ]; then
      dest="$HOME/.local/share/applications/$entry"

      cp "$src" "$dest"
      sudo chmod 666 "$dest"

      # Add Hidden=true (or replace if already set)
      if grep -q 'Hidden=' "$dest"; then
        sed -i 's/^Hidden=.*/Hidden=true/' "$dest"
      else
        sed -i '2iHidden=true' "$dest"
      fi

      echo " -> Copied and marked hidden: $dest"
      break
    fi
  done
done <"$LIST_FILE"
