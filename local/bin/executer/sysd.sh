#!/usr/bin/env bash
# https://github.com/colonelpanic8/rofi-systemd/blob/master/rofi-systemd
set -euo pipefail

# Configuration
THEME_DIR="$HOME/.config/rofi"
THEME_FILE="$THEME_DIR/shared.rasi"
STATUS_THEME="$THEME_DIR/Status.rasi"
SYSTEMCTL_THEME="$THEME_DIR/Systemctl.rasi"
MAX_WIDTH=100

# Get colors from theme
get_theme_color() {
  awk -F: "/$1:/ {print \$2}" "$THEME_FILE" | tr -d ' ;'
}

ENABLED_COLOR=$(get_theme_color "active")
DISABLED_COLOR=$(get_theme_color "urgent")

fetch_services() {
  local unit_type=$1 && shift 1
  if [[ $unit_type == "all" ]]; then
    systemctl list-unit-files --no-pager --no-legend "$@" |
      awk '$2~/^(disabled|enabled|generated|linked)$/{print $1,$2,$3}'
  else
    systemctl list-units --type="$unit_type" --no-pager --no-legend "$@" |
      awk '$4=="running"{$2=$3="";print}' | while read -r service; do
      printf "%s %s\n" "$(awk '{print $1}' <<<"$service")" \
        "$(systemctl show -p Description "$(awk '{print $1}' <<<"$service")" "$@" | cut -d= -f2)"
    done
  fi
}

# Format services for display
format_services() {
  if [[ $1 == "all" ]]; then
    awk -v enabled="$ENABLED_COLOR" -v disabled="$DISABLED_COLOR" -v width="$MAX_WIDTH" '{
        service_name = $1;
        state = $2;
        preset = $3;
        padding = width - length(service_name) - length(state);
        spaces = (padding > 0) ? sprintf("%*s", padding, "") : "";
        if (state == "enabled")
          printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, enabled, state;
        else if (state == "disabled")
          printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, disabled, state;
        else if (state == "linked")
          if (preset == "enabled")
            printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, enabled, preset;
          else if (preset == "disabled")
            printf "%s%s<span foreground=\"%s\">%s</span>\n", service_name, spaces, disabled, preset;
      }'
  else
    awk -v width="$MAX_WIDTH" '{
        service_name = $1;
        description = substr($0, index($0, $2));
        padding = width - length(service_name) - length(description);
        spaces = (padding > 0) ? sprintf("%*s", padding, "") : "";
        printf "%s%s%s\n", service_name, spaces, description;
      }'
  fi
}

show_menu() {
  local opts=(-dmenu -p "Select a ${2^}:" -theme "$SYSTEMCTL_THEME")
  [[ $2 == "all" ]] && opts+=(-markup-rows)
  rofi "${opts[@]}" <<<"$1"
}

case $1 in
--service | --socket | --all)
  unit=${1#--}
  services=$(fetch_services "$unit" ${2:+"$2"})
  selected=$(show_menu "$(format_services "$unit" <<<"$services")" "$unit")
  ;;
--service-user | --socket-user | --all-user) exec "$0" "${1%-user}" --user ;;
esac

[[ -n $selected ]] && rofi -e "$(systemctl status "$(awk '{print $1}' <<<"$selected")" ${2:+"$2"})" -theme "$STATUS_THEME"
