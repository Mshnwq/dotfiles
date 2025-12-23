#!/usr/bin/env bash

CONF="$HOME/.config/kitty/kitty.conf"

if [[ $1 == "--hide" ]]; then
  read -r -d '' conf_block <<"EOF"
single_window_padding_width -1
window_padding_width 0 0 0 0
window_border_width 1pt
tab_bar_align right
tab_bar_min_tabs 9
EOF
else
  read -r -d '' conf_block <<"EOF"
window_padding_width 0 0 2 0
window_border_width 1pt
tab_bar_style custom
tab_bar_edge top
tab_bar_align right
tab_bar_min_tabs 1
tab_activity_symbol none
tab_separator ""
tab_bar_margin_width 0
window_margin_width 0
tab_bar_margin_height 3.5 0
active_tab_font_style   bold
tab_title_template "{title.split('/')[-1]}"
EOF
#tab_title_template "{index}┊{title.split('/')[-1]}"
fi

# Use sed to delete lines between the markers
sed -i '/# -- start replace/,/# -- end replace/{
  /# -- start replace/!{/# -- end replace/!d}
}' "$CONF"
# Insert the new block after "-- start replace"
sed -i "/-- start replace/r /dev/stdin" "$CONF" <<<"$conf_block"
