#!/usr/bin/env bash

rice=$(<"$HOME/.config/dots/.rice")
assets_dir="$HOME/.config/dots/rices/$rice/assets"

# shellcheck disable=SC1091
source "$HOME/.cache/wal/colors.sh"

magick -size 64x64 xc:transparent -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' -pointsize 64 -draw 'gravity center text 0 0 ""' "$assets_dir/brightness.png"
magick -size 64x64 xc:transparent -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' -pointsize 64 -draw 'gravity center text 0 0 "󰕾"' "$assets_dir/volume_high.png"
magick -size 64x64 xc:transparent -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' -pointsize 64 -draw 'gravity center text 0 0 "󰖀"' "$assets_dir/volume_medium.png"
magick -size 64x64 xc:transparent -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' -pointsize 64 -draw 'gravity center text 0 0 "󰕿"' "$assets_dir/volume_low.png"
magick -size 64x64 xc:transparent -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' -pointsize 64 -draw 'gravity center text 0 0 "󰝟"' "$assets_dir/volume_mute.png"
sh -c "$HOME/.local/bin/executer/.dunst_start.sh"
