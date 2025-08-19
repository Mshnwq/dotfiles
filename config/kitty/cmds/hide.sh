#!/bin/env bash

kitty_file="$HOME/.config/kitty/kitty.conf"
conf_block='
single_window_padding_width -1
window_padding_width 0 0 0 0
window_border_width 1pt
tab_bar_align right
tab_bar_margin_height 3 0
tab_bar_style hidden
' # Use sed to delete lines between the markers
sed -i '/# -- start replace/,/# -- end replace/{
  /# -- start replace/!{/# -- end replace/!d}
}' "$kitty_file"
# Insert the new block after "-- start replace"
sed -i "/-- start replace/r /dev/stdin" "$kitty_file" <<<"$conf_block"
