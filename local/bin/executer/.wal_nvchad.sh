#!/usr/bin/env bash

nvchad_file="$HOME/.config/nvim/lua/chadrc_pywal.lua"
nvchad_theme="$HOME/.cache/wal/custom-nvchad.sh"
chadwal_theme="$HOME/.cache/wal/base46-dark.lua"
base46_theme="$HOME/.local/share/nvim/lazy/base46/lua/base46/themes/chadwal.lua"
cp "$chadwal_theme" "$base46_theme"

# Delete the old block between the markers
sed -i '/  -- start replace from rice/,/  -- end replace from rice/{
  /  -- start replace from rice/!{/  -- end replace from rice/!d}
}' "$nvchad_file"

# Read the theme file into a variable
theme_block="$(<"$nvchad_theme")"

# Rewrite the .nvchad.lua file with the new block inserted between the markers
awk -v block="$theme_block" '
  BEGIN { in_block = 0 }
  {
    if ($0 ~ /  -- start replace from rice/) {
      print $0
      print block
      in_block = 1
      next
    }
    if ($0 ~ /  -- end replace from rice/) {
      in_block = 0
    }
    if (!in_block) {
      print $0
    }
  }
' "$nvchad_file" >"${nvchad_file}.tmp" && mv "${nvchad_file}.tmp" "$nvchad_file"

for addr in "$XDG_RUNTIME_DIR"/nvim.*; do
  nvim --server "$addr" --remote-send ':lua require("nvchad.utils").reload() <cr>'
done
