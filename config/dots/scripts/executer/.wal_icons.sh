#!/usr/bin/env bash

pywal_dir="$HOME/.cache/wal/Papirus/Pywal"
papirus_dir="$HOME/.local/share/icons/Papirus"

find "$pywal_dir" -type f -path "*/places/*.svg" | while read -r src; do
    rel_path="${src#$pywal_dir/}"    # remove base path
    dest="$papirus_dir/$rel_path"
    mkdir -p "$(dirname "$dest")"   # ensure destination dir exists
    if [ ! -e "$dest" ]; then
      ln -sf "$src" "$dest"
      echo "$src -> $dest"
    fi
done

papirus-folders -C cat-mocha-pywal --theme Papirus-Dark
