#!/bin/bash

# Get all service units and their states
services=$(systemctl --user list-unit-files --no-pager --no-legend |
  awk '$2 == "disabled" || $2 == "enabled" {print $1, $2}')

# Fetch enabled and disabled colors from the theme file
theme="$HOME/.config/rofi/shared.rasi"
enabled_color=$(awk -F: '/active:/ {print $2}' "$theme" | tr -d ' ;')
disabled_color=$(awk -F: '/urgent:/ {print $2}' "$theme" | tr -d ' ;')

max_width=98 # Adjust this to fit your Rofi window width
# Format the output with Pango markup for color and alignment
formatted_services=$(echo "$services" | awk -v enabled="$enabled_color" -v disabled="$disabled_color" -v width="$max_width" '{
    service_name = $1;
    status = $2;
    
    # Calculate padding for alignment
    padding = width - length(service_name) - length(status);
    spaces = (padding > 0) ? sprintf("%*s", padding, "") : "";

    # Format the row with color
    if (status == "enabled")
        printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, enabled, status;
    else if (status == "disabled")
        printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, disabled, status;
}')

# Show the formatted services in a Rofi menu
selected=$(echo -e "$formatted_services" | rofi -dmenu -markup-rows -p "Select a service:" \
  -theme "$HOME/.config/rofi/Systemctl.rasi" "$@")

# Exit if no selection is made
if [ -z "$selected" ]; then
  exit 0
fi

# Extract the service name from the selected entry
service_name=$(echo "$selected" | awk '{print $1}')

# Show service status or take action
rofi -e "$(systemctl --user status "$service_name")" -theme "$HOME/.config/rofi/Status.rasi" "$@"
