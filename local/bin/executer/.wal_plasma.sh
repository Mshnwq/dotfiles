#!/usr/bin/env bash

pywal_dir="$HOME/.cache/wal/Papirus/Pywal"
papirus_dir="$HOME/.local/share/icons/Papirus"

find "$pywal_dir" -type f -path "*/places/*.svg" | while read -r src; do
  rel_path="${src#$pywal_dir/}"
  dest="$papirus_dir/$rel_path"
  mkdir -p "$(dirname "$dest")"
  cp -f "$src" "$dest"
  # echo "$src -> $dest"
done

papirus-folders -C cat-mocha-pywal --theme Papirus-Dark
plasma-apply-colorscheme BreezeDark
plasma-apply-colorscheme Pywal
