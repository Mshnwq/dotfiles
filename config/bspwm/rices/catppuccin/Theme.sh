#!/usr/bin/env bash
#  Author  :  z0mbi3
#  Url     :  https://github.com/gh0stzk/dotfiles
#  About   :  This file will configure and launch the rice.

# Current Rice
read -r RICE <"$HOME"/.config/bspwm/.rice

# Load sources
. "${HOME}"/.config/bspwm/src/Process.bash
. "${HOME}"/.config/bspwm/rices/${RICE}/theme-config.bash
. "${HOME}"/.config/bspwm/src/WallEngine.bash

# Set bspwm configuration
set_bspwm_config() {
  bspc config border_width ${BORDER_WIDTH}
  bspc config normal_border_color "${NORMAL_BC}"
  bspc config focused_border_color "${FOCUSED_BC}"
  bspc config presel_feedback_color "${magenta}"
}

# Terminal colors
set_term_config() {
  sed -i "$HOME"/.config/alacritty/alacritty.toml \
    -e "s/opacity = .*/opacity = $term_opacity/"

  sed -i "$HOME"/.config/alacritty/fonts.toml \
    -e "s/size = .*/size = $a_term_font_size/" \
    -e "s/family = .*/family = \"$term_font_name\"/"

  cat >"$HOME"/.config/alacritty/rice-colors.toml <<-EOF
		# Default colors
		[colors.primary]
		background = "${bg}"
		foreground = "${fg}"

		# Cursor colors
		[colors.cursor]
		text = "${bg}"
		cursor = "${cyan}"

		# Normal colors
		[colors.normal]
		black = "${black}"
		red = "${red}"
		green = "${green}"
		yellow = "${yellow}"
		blue = "${blue}"
		magenta = "${magenta}"
		cyan = "${cyan}"
		white = "${white}"

		# Bright colors
		[colors.bright]
		black = "${blackb}"
		red = "${redb}"
		green = "${greenb}"
		yellow = "${yellowb}"
		blue = "${blueb}"
		magenta = "${magentab}"
		cyan = "${cyanb}"
		white = "${whiteb}"
	EOF

  # Set kitty colorscheme
  cat >"$HOME"/.config/kitty/current-theme.conf <<-EOF
                
		# Base
		font_family ${term_font_name}
		font_size ${k_term_font_size}
		background_opacity ${term_opacity}

		# The basic colors
		foreground              ${fg}
		background              ${bg}
		selection_foreground    ${bg}
		selection_background    ${green}

		# Cursor colors
		cursor                  ${cyan}
		cursor_text_color       ${bg}

		# URL underline color when hovering with mouse
		url_color               ${blue}

		# Kitty window border colors
		active_border_color     ${green}
		inactive_border_color   ${blackb}
		bell_border_color       ${yellow}

		# Tab bar colors
		active_tab_foreground   ${bg}
		active_tab_background   ${green}
		inactive_tab_foreground ${white}
		inactive_tab_background ${black}
		tab_bar_background      ${bg}

		# The 16 terminal colors

		# black
		color0 ${black}
		color8 ${blackb}

		# red
		color1 ${red}
		color9 ${redb}

		# green
		color2  ${green}
		color10 ${greenb}

		# yellow
		color3  ${yellow}
		color11 ${yellowb}

		# blue
		color4  ${blue}
		color12 ${blueb}

		# magenta
		color5  ${magenta}
		color13 ${magentab}

		# cyan
		color6  ${cyan}
		color14 ${cyanb}

		# white
		color7  ${white}
		color15 ${whiteb}
	EOF

  pidof -q kitty && killall -USR1 kitty
}

# Set p10k color
set_p10k_config() {
  p10k_file="$HOME/.p10k.zsh"
  theme_block='
  local white='#F1F1F0'
  local bg='#181825'
  local fg='#cdd6f4'
  local red='#f38ba8'
  local pink='#f5c2e7'
  local purple='#cba6f7'
  local blue='#89b4fa'
  local cyan='#94e2d5'
  local green='#a6e3a1'
  local yellow='#f9e2af'
  local lavander='#b4befe'
  local peach='#f2d5cf'
  local amber='#ff77a0'
  local orange='#fab387'
  local brown='#f2cdcd'
  local grey='#73739c'
  local indigo='#9399b2'
  ' # Use sed to delete lines between the markers
  sed -i '/# -- start replace from rice/,/# -- end replace from rice/{
    /# -- start replace from rice/!{/# -- end replace from rice/!d}
  }' "$p10k_file"
  # Insert the new block after "-- start replace from rice"
  sed -i "/-- start replace from rice/r /dev/stdin" "$p10k_file" <<<"$theme_block"
}

# Set nvim color
set_nvim_config() {
  nvim_file="$HOME/.config/nvim/lua/chadrc.lua"
  theme_block='
  theme = "catppuccin",
  hl_override = {
    St_NormalMode = { bg = "cyan" },
    St_NormalModeSep = { fg = "cyan" },
    St_InsertMode = { bg = "'${purple}'" },
    St_InsertModeSep = { fg = "'${purple}'" },
    St_VisualMode = { bg = "green" },
    St_VisualModeSep = { fg = "green" },
    St_CommandMode = { bg = "yellow" },
    St_CommandModeSep = { fg = "yellow" },
    -- St_pos_text = { bg = "none" }
  },
  hl_add = {
    St_Lint = { fg = "yellow", bg = "none" },
    NotifyINFOIcon = { fg = "green" },
    NotifyINFOTitle = { fg = "green" },
    NotifyINFOBorder = { fg = "grey_fg" },
    NotifyERRORIcon = { fg = "red" },
    NotifyERRORTitle = { fg = "red" },
    NotifyERRORBorder = { fg = "grey_fg" },
    NotifyWARNIcon = { fg = "yellow" },
    NotifyWARNTitle = { fg = "yellow" },
    NotifyWARNBorder = { fg = "grey_fg" },
    TodoError = { fg = "red" },
    TodoWarn = { fg = "'${purple}'" },
    TodoInfo = { fg = "yellow" },
    TodoHint = { fg = "green" },
    TodoTest = { fg = "cyan" },
    TodoDefault = { fg = "grey_fg" },
  },
  '

  # Use sed to delete lines between the markers
  sed -i '/-- start replace from rice/,/-- end replace from rice/{
    /-- start replace from rice/!{/-- end replace from rice/!d}
  }' "$nvim_file"
  # Insert the new block after "-- start replace from rice"
  sed -i "/-- start replace from rice/r /dev/stdin" "$nvim_file" <<<"$theme_block"
  # then loop over all nvim instances and send the function!
  for addr in $XDG_RUNTIME_DIR/nvim.*; do
    nvim --server $addr --remote-send ':lua require("nvchad.utils").reload() <cr>'
  done
}

# Set tmux color
set_tmux_config() {
  tmux_file="$HOME/.tmux.conf"

  sed -i "$tmux_file" \
    -e "/#-main-fg-dark_gray/s/.*#-/dark_gray='${bg}'\t#-/" \
    -e "/#-main-bg-normal-green/s/.*#-/green='${cyan}'\t#-/" \
    -e "/#-main-bg-action-yellow/s/.*#-/yellow='${yellow}'\t#-/" \
    -e "/#-select-bg-dark_purple/s/.*#-/dark_purple='${purple}'\t#-/" \
    -e "/#-mpc_fg/s/.*#-/mpc_fg='${bg}'\t#-/" \
    -e "/#-mpc_bg/s/.*#-/mpc_bg='${green}'\t#-/" \
    -e "/#-fg/s/.*#-/fg='${fg}'\t#-/" \
    -e "/#-bg/s/.*#-/bg='${bg}'\t#-/" \
    -e "/#-invert-select-window/s/.*#-/set -g @dracula-invert-select-window-fg ${tmuxw}\t#-/"

  tmux source-file "$HOME/.tmux.conf"
}

# Set Yazi color
set_yazi_config() {
  cat >"$HOME"/.config/yazi/theme.toml <<-EOF
		[status]

		separator_open = "\ue0be"
		separator_close = "\ue0b8"


		[mode]

		normal_main = { fg = "${bg}", bg = "${cyan}", bold = true }
		normal_alt  = { fg = "${cyan}", bg = "${black}" }

		select_main = { fg = "${bg}", bg = "${green}", bold = true }
		select_alt  = { fg = "${green}", bg = "${black}" }

		unset_main = { fg = "${bg}", bg = "${yellow}", bold = true }
		unset_alt  = { fg = "${yellow}", bg = "${black}" }
	EOF
}

# Set compositor configuration
set_picom_config() {
  picom_conf_file="$HOME/.config/bspwm/src/config/picom.conf"
  picom_animations_file="$HOME/.config/bspwm/src/config/picom-animations.conf"

  sed -i "$picom_conf_file" \
    -e "s/shadow-color = .*/shadow-color = \"${SHADOW_C}\"/" \
    -e "s/^corner-radius = .*/corner-radius = ${P_CORNER_R}/" \
    -e "/#-term-opacity-switch/s/.*#-/\t\topacity = $P_TERM_OPACITY;\t#-/" \
    -e "/#-widget-opacity-switch/s/.*#-/\t\topacity = $P_WIDGET_OPACITY;\t#-/" \
    -e "/#-shadow-switch/s/.*#-/\t\tshadow = ${P_SHADOWS};\t#-/" \
    -e "/#-fade-switch/s/.*#-/\t\tfade = ${P_FADE};\t#-/" \
    -e "/#-blur-switch/s/.*#-/\t\tblur-background = ${P_BLUR};\t#-/" \
    -e "/picom-animations/c\\${P_ANIMATIONS}include \"picom-animations.conf\""

  sed -i "$picom_animations_file" \
    -e "/#-dunst-close-preset/s/.*#-/\t\tpreset = \"fly-out\";\t#-/" \
    -e "/#-dunst-close-direction/s/.*#-/\t\tdirection = \"up\";\t#-/" \
    -e "/#-dunst-open-preset/s/.*#-/\t\tpreset = \"fly-in\";\t#-/" \
    -e "/#-dunst-open-direction/s/.*#-/\t\tdirection = \"up\";\t#-/"
}

# Set dunst config
set_dunst_config() {
  dunst_config_file="$HOME/.config/bspwm/src/config/dunstrc"

  sed -i "$dunst_config_file" \
    -e "s/origin = .*/origin = ${dunst_origin}/" \
    -e "s/offset = .*/offset = ${dunst_offset}/" \
    -e "s/transparency = .*/transparency = ${dunst_transparency}/" \
    -e "s/^corner_radius = .*/corner_radius = ${dunst_corner_radius}/" \
    -e "s/frame_width = .*/frame_width = ${dunst_border}/" \
    -e "s/frame_color = .*/frame_color = \"${whiteb}\"/" \
    -e "s/font = .*/font = ${dunst_font} 12/" \
    -e "s/foreground='.*'/foreground='${green}'/" \
    -e "s/icon_theme = .*/icon_theme = \"${gtk_icons}, Adwaita\"/"

  sed -i '/urgency_low/Q' "$dunst_config_file"
  cat >>"$dunst_config_file" <<-_EOF_
		[urgency_low]
		timeout = 3
		background = "${bg}"
		foreground = "${green}"

		[urgency_normal]
		timeout = 5
		background = "${bg}"
		foreground = "${fg}"

		[urgency_critical]
		timeout = 0
		background = "${bg}"
		foreground = "${red}"
	_EOF_

  dunstctl reload "$dunst_config_file"
}

# Set eww colors
set_eww_colors() {
  cat >"$HOME"/.config/bspwm/eww/colors.scss <<-EOF
		\$bg: ${bg};
		\$bg-alt: #1e1e2e;
		\$fg: ${fg};
		\$black: ${black};
		\$red: ${red};
		\$green: ${green};
		\$yellow: ${yellow};
		\$blue: ${blue};
		\$magenta: ${magenta};
		\$cyan: ${cyan};
		\$archicon: #0f94d2;
	EOF
}

set_launchers() {
  # Jgmenu
  sed -i "$HOME"/.config/bspwm/src/config/jgmenurc \
    -e "s/color_menu_bg = .*/color_menu_bg = ${bg}/" \
    -e "s/color_norm_fg = .*/color_norm_fg = ${fg}/" \
    -e "s/color_sel_bg = .*/color_sel_bg = #1e1e2e/" \
    -e "s/color_sel_fg = .*/color_sel_fg = ${fg}/" \
    -e "s/color_sep_fg = .*/color_sep_fg = ${black}/"

  # Rofi launchers
  cat >"$HOME"/.config/bspwm/src/rofi-themes/shared.rasi <<-EOF
		// Rofi colors for Daniela

		* {
		    font: "${dunst_font} 12";
		    background: ${bg};
		    bg-alt: #1e1e2e;
		    background-alt: ${bg}E0;
		    foreground: ${fg};
		    selected: ${purple};
		    active: ${green};
		    urgent: ${red};

		    img-background: url("~/.config/bspwm/rices/${RICE}/rofi.webp", width);
		}
	EOF

  # Screenlock colors
  sed -i "$HOME"/.config/bspwm/src/ScreenLocker \
    -e "s/bg=.*/bg=${bg:1}/" \
    -e "s/fg=.*/fg=${fg:1}/" \
    -e "s/ring=.*/ring=${magenta:1}/" \
    -e "s/wrong=.*/wrong=${red:1}/" \
    -e "s/date=.*/date=${fg:1}/" \
    -e "s/verify=.*/verify=${green:1}/"
}

# set_appearance() {
#   # Set the gtk theme corresponding to rice
#   sed -i "$HOME"/.config/bspwm/src/config/xsettingsd \
#     -e "s|Net/ThemeName .*|Net/ThemeName \"$gtk_theme\"|" \
#     -e "s|Net/IconThemeName .*|Net/IconThemeName \"$gtk_icons\"|" \
#     -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$gtk_cursor\"|"
#
#   sed -i -e "s/Inherits=.*/Inherits=$gtk_cursor/" "$HOME"/.icons/default/index.theme
#
#   # Reload daemon and apply gtk theme
#   pkill -1 xsettingsd
#   xsetroot -cursor_name left_ptr
# }

# Apply Geany Theme
# set_geany() {
#   sed -i ${HOME}/.config/geany/geany.conf \
#     -e "s/color_scheme=.*/color_scheme=$geany_theme.conf/g"
# }

# Launch theme
launch_theme() {
  # Launch polybar
  FlipBar --up --force
}

### Apply Configurations

set_bspwm_config
set_term_config
set_p10k_config
set_nvim_config
set_tmux_config
set_yazi_config
set_picom_config
set_dunst_config
set_eww_colors
set_launchers
# set_geany
# TODO: firefox, gtk, qt
# set_firefox
# set_appearance
launch_theme
