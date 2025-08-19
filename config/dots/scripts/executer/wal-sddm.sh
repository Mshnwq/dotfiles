#!/usr/bin/env bash

# variables
read -r wallpaper_path <"$HOME"/.config/dots/rices/.wall
sddm_simple="/opt/sddm/themes/simple_sddm_2"
sddm_theme_conf="$sddm_simple/theme.conf"
colors_wallust="$HOME/.cache/wal/colors.css"

# Extract colors from colors wallust config
color1=$(grep -oP 'color0:\s*\K#[A-Fa-f0-9]+' "$colors_wallust")
color7=$(grep -oP 'color14:\s*\K#[A-Fa-f0-9]+' "$colors_wallust")
color10=$(grep -oP 'color10:\s*\K#[A-Fa-f0-9]+' "$colors_wallust")
color12=$(grep -oP 'color12:\s*\K#[A-Fa-f0-9]+' "$colors_wallust")
color13=$(grep -oP 'color13:\s*\K#[A-Fa-f0-9]+' "$colors_wallust")

# Update the colors in the SDDM config
sudo sed -i "s/HeaderTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/HeaderTextColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/DateTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/DateTextColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/TimeTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/TimeTextColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/DropdownSelectedBackgroundColor=\"#\([0-9A-Fa-f]\{6\}\)\"/DropdownSelectedBackgroundColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/SystemButtonsIconsColor=\"#\([0-9A-Fa-f]\{6\}\)\"/SystemButtonsIconsColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/SessionButtonTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/SessionButtonTextColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/VirtualKeyboardButtonTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/VirtualKeyboardButtonTextColor=\"$color13\"/" "$sddm_theme_conf"
sudo sed -i "s/HighlightBackgroundColor=\"#\([0-9A-Fa-f]\{6\}\)\"/HighlightBackgroundColor=\"$color12\"/" "$sddm_theme_conf"
sudo sed -i "s/LoginFieldTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/LoginFieldTextColor=\"$color12\"/" "$sddm_theme_conf"
sudo sed -i "s/PasswordFieldTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/PasswordFieldTextColor=\"$color12\"/" "$sddm_theme_conf"

sudo sed -i "s/DropdownBackgroundColor=\"#\([0-9A-Fa-f]\{6\}\)\"/DropdownBackgroundColor=\"$color1\"/" "$sddm_theme_conf"
sudo sed -i "s/HighlightTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/HighlightTextColor=\"$color10\"/" "$sddm_theme_conf"

sudo sed -i "s/PlaceholderTextColor=\"#\([0-9A-Fa-f]\{6\}\)\"/PlaceholderTextColor=\"$color7\"/" "$sddm_theme_conf"
sudo sed -i "s/UserIconColor=\"#\([0-9A-Fa-f]\{6\}\)\"/UserIconColor=\"$color7\"/" "$sddm_theme_conf"
sudo sed -i "s/PasswordIconColor=\"#\([0-9A-Fa-f]\{6\}\)\"/PasswordIconColor=\"$color7\"/" "$sddm_theme_conf"

# Copy wallpaper to SDDM theme
sudo cp $wallpaper_path $sddm_simple/Backgrounds/default
