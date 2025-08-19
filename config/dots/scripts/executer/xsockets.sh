#!/bin/bash

# Fetch running socket and their descriptions
services=$(systemctl list-units --type=socket --no-pager --no-legend |
  awk '$4 == "running" {$2=$3=""; print $0}' | while read -r service; do
  service_name="$(echo "$service" | awk '{print $1}')"
  description="$(systemctl show -p Description "$service_name" | sed 's/Description=//')"
  echo "$service_name $description"
done)


max_width=100 # Adjust this to fit your Rofi window width
# Format the output with Pango markup for color and alignment
formatted_services=$(echo "$services" | awk -v width="$max_width" '{
    service_name = $1;
    description = substr($0, index($0, $2)); # everything after the first space
    
    # Calculate padding for alignment
    padding = width - length(service_name) - length(description);
    spaces = (padding > 0) ? sprintf("%*s", padding, "") : "";

    printf "%s%s%s\n", service_name, spaces, description;
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
rofi -e "$(systemctl status "$service_name")" -theme "$HOME/.config/rofi/Status.rasi" "$@"
