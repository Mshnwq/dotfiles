# (Tokyo-Night) colorscheme
bg="#1a1b26"
fg="#a9b1d6"

grey="#565f89"
black="#414868"
blackb="#414868"
white="#c0caf5"
whiteb="#c0caf5"
yellow="#EBCB8B"
yellowb="#ffff99"
orange="#ffb964"
orangeb="#e0af68"
red="#f7768e"
redb="#ff75a0"
peach="#ffd0d0"
purple="#9d7cd8"
purpleb="#bb9af7"
magenta="#8656e3"
magentab="#8656e3"
blue="#7aa2f7"
blueb="#5f90ea"
teal="#73daca"
tealb="#87eef0"
cyan="#7dcfff"
cyanb="#87ffff"
green="#9ece6a"
greenb="#9efe6a"

# for when bad contrast tmux select window
tmuxw="true"

# Bspwm options
BORDER_WIDTH="2.5"		# Bspwm border
NORMAL_BC="#414868"		# Normal border color
FOCUSED_BC="#414868"	# Focused border color
bspc_left_padding="2"
bspc_right_padding="2"
# need match bar height + padding (37+2)
bspc_bar_padding="48"

# Terminal font & size
term_opacity="0.82"
term_font_name="JetBrainsMono Nerd Font"
a_term_font_size="12"
k_term_font_size="16"

# Picom options
P_FADE="true"			# Fade true|false
P_SHADOWS="false"		# Shadows true|false
SHADOW_C="#000000"		# Shadow color
P_CORNER_R="6"			# Corner radius (0 = disabled)
P_BLUR="false"			# Blur true|false
P_ANIMATIONS="#"		# (@ = enable) (# = disable)
P_TERM_OPACITY="0.88"	# Terminal transparency. Range: 0.1 - 1.0 (1.0 = disabled)
P_WIDGET_OPACITY="0.86"	# Widgets transparency. Range: 0.1 - 1.0 (1.0 = disabled)

# Dunst
dunst_offset='(20, 60)'
dunst_origin='top-right'
dunst_transparency='8'
dunst_corner_radius='0'
dunst_font='JetBrainsMono NF Medium 9'
dunst_border='2'

# Gtk theme vars
gtk_theme="z0mbi3Night-zk"
gtk_icons="Sweet-Rainbow"
gtk_cursor="Qogirr-Dark"
geany_theme="z0mbi3-z0mbi3Night"

# Wallpaper engine
# Available engines:
# - Theme	(Set a random wallpaper from rice directory)
# - CustomDir	(Set a random wallpaper from the directory you specified)
# - CustomImage	(Sets a specific image as wallpaper)
# - CustomAnimated (Set an animated wallpaper. "mp4, mkv, gif")
ENGINE="Theme"
CUSTOM_DIR="/path/to/dir"
CUSTOM_WALL="/path/to/image"
CUSTOM_ANIMATED="$HOME/.config/bspwm/src/assets/animated_wall.mp4"
