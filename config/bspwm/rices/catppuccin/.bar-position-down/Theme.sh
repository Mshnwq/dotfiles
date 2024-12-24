#!/usr/bin/env bash
#  ██████╗  █████╗ ███╗   ██╗██╗███████╗██╗      █████╗     ██████╗ ██╗ ██████╗███████╗
#  ██╔══██╗██╔══██╗████╗  ██║██║██╔════╝██║     ██╔══██╗    ██╔══██╗██║██╔════╝██╔════╝
#  ██║  ██║███████║██╔██╗ ██║██║█████╗  ██║     ███████║    ██████╔╝██║██║     █████╗
#  ██║  ██║██╔══██║██║╚██╗██║██║██╔══╝  ██║     ██╔══██║    ██╔══██╗██║██║     ██╔══╝
#  ██████╔╝██║  ██║██║ ╚████║██║███████╗███████╗██║  ██║    ██║  ██║██║╚██████╗███████╗
#  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝
#  Author  :  z0mbi3
#  Url     :  https://github.com/gh0stzk/dotfiles
#  About   :  This file will configure and launch the rice.
#

# Current Rice
read -r RICE < "$HOME"/.config/bspwm/.rice

# Load sources
. "${HOME}"/.config/bspwm/src/Process.bash
. "${HOME}"/.config/bspwm/rices/${RICE}/theme-config.bash
. "${HOME}"/.config/bspwm/src/WallEngine.bash

# Set bspwm configuration
set_bspwm_config() {
	bspc config border_width ${BORDER_WIDTH}
	bspc config top_padding 1  
	# need match bar height + one
	bspc config bottom_padding 56
	bspc config left_padding 1
	bspc config right_padding 1
	bspc config normal_border_color "${NORMAL_BC}"
	bspc config focused_border_color "${FOCUSED_BC}"
	bspc config presel_feedback_color "${magenta}"
}

# Terminal colors
set_term_config() {
	sed -i "$HOME"/.config/alacritty/fonts.toml \
		-e "s/size = .*/size = $term_font_size/" \
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
}

# Set tmux color
set_tmux_config() {
	tmux_file="$HOME/.tmux.conf"

	sed -i "$tmux_file" \
		-e "/#-main-fg-dark_gray/s/.*#-/dark_gray='${bg}'\t#-/" \
		-e "/#-main-bg-normal-green/s/.*#-/green='${blue}'\t#-/" \
		-e "/#-main-bg-action-yellow/s/.*#-/yellow='${yellow}'\t#-/" \
		-e "/#-select-fg-dark_purple/s/.*#-/dark_purple='${tmuxw}'\t#-/" \
		-e "/#-mpc_fg/s/.*#-/mpc_fg='${bg}'\t#-/" \
		-e "/#-mpc_bg/s/.*#-/mpc_bg='${magenta}'\t#-/" \
		-e "/#-fg/s/.*#-/fg='${fg}'\t#-/" \
		-e "/#-bg/s/.*#-/bg='${bg}'\t#-/" \
		-e "/#-invert-select-window/s/.*#-/set -g @dracula-invert-select-window-fg ${tmuxw}\t#-/"

	tmux source-file "$HOME/.tmux.conf"
}

# Set compositor configuration
set_picom_config() {
	picom_conf_file="$HOME/.config/bspwm/src/config/picom.conf"
	picom_animations_file="$HOME/.config/bspwm/src/config/picom-animations.conf"

	sed -i "$picom_conf_file" \
		-e "s/shadow-color = .*/shadow-color = \"${SHADOW_C}\"/" \
		-e "s/^corner-radius = .*/corner-radius = ${P_CORNER_R}/" \
		-e "/#-term-opacity-switch/s/.*#-/\t\topacity = $P_TERM_OPACITY;\t#-/" \
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
		-e "s/font = .*/font = ${dunst_font}/" \
		-e "s/foreground='.*'/foreground='${magenta}'/" \
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
		    font: "JetBrainsMono NF Bold 9";
		    background: ${bg};
		    bg-alt: #1e1e2e;
		    background-alt: ${bg}E0;
		    foreground: ${fg};
		    selected: ${magenta};
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

set_appearance() {
	# Set the gtk theme corresponding to rice
	sed -i "$HOME"/.config/bspwm/src/config/xsettingsd \
		-e "s|Net/ThemeName .*|Net/ThemeName \"$gtk_theme\"|" \
		-e "s|Net/IconThemeName .*|Net/IconThemeName \"$gtk_icons\"|" \
		-e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$gtk_cursor\"|"

	sed -i -e "s/Inherits=.*/Inherits=$gtk_cursor/" "$HOME"/.icons/default/index.theme

	# Reload daemon and apply gtk theme
	pkill -1 xsettingsd
	xsetroot -cursor_name left_ptr
}

# Apply Geany Theme
set_geany(){
	sed -i ${HOME}/.config/geany/geany.conf \
		-e "s/color_scheme=.*/color_scheme=$geany_theme.conf/g"
}

# Launch theme
launch_theme() {
	# Launch polybar
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q dani -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &
	done
	echo "up" > "${HOME}"/.config/bspwm/rices/${RICE}/.bar-position
}

### Apply Configurations

set_bspwm_config
set_term_config
set_tmux_config
set_picom_config
set_appearance
set_dunst_config
set_eww_colors
set_launchers
set_geany
launch_theme
