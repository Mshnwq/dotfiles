#!/usr/bin/env bash

cursor_dir="$HOME/.build/cursors"
cursor_file="$cursor_dir/src/templates/svgs.tera"
cache_dir="$HOME/.cache/wal/cursors"

# Get current wallpaper (assuming pywal stores it here)
WALLPAPER="$(< ~/.cache/wal/wal)"

# Create a unique hash or name from the wallpaper path
wallpaper_hash=$(echo "$WALLPAPER" | sha256sum | cut -d' ' -f1)
cache_path="$cache_dir/$wallpaper_hash"

# Load pywal colors
source "$HOME/.cache/wal/colors.sh"

# Replace FF0000 with pywal color3 in cursor template
sed -i -E 's|(replace\(from="FF0000", to=")[^"]*(")|\1'"${color3#\#}"'\2|' "$cursor_file"

# Use cached build if available
if [[ -d "$cache_path" ]]; then
  echo "Cached cursor found. Using it."
  rm -r "$cursor_dir/dist/"
  cp -r "$cache_path/" "$cursor_dir/dist/"
else
  echo "No cache found. Building new cursor."
  cd "$cursor_dir"
  cp "$cursor_dir/src/default.svg" "$cursor_dir/src/svgs/default.svg"

  export NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/master.tar.gz
  if nix-shell --run "just build mocha pywal"; then
    echo "Build successful. Saving to cache."
    mkdir -p "$cache_path"
    cp -r "$cursor_dir/dist/catppuccin-mocha-pywal-cursors" "$cache_path"
  else
    echo "Build failed. Cache not created."
    exit 1
  fi
fi

# Set the cursor theme
hyprctl setcursor 'Catppuccin Mocha Pywal' 18
