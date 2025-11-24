#!/usr/bin/env bash

# Define functions
print_error() {
  cat <<"EOF"
Usage: ./volumecontrol.sh -[device] <actions>
...valid devices are...
    i   -- input device
    o   -- output device
    p   -- player application
...valid actions are...
    i   -- increase volume [+5]
    d   -- decrease volume [-5]
    m   -- mute [x]
EOF
  exit 1
}

icon() {
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $5}')

  RICE=$(cat ~/.config/dots/.rice)
  ASSETS_DIR="$HOME/.config/dots/rices/$RICE/assets"
  if [ "$mute" = "yes" ] || [ "$vol" -eq 0 ]; then
    icon="$ASSETS_DIR/volume_mute.png"
  elif [ "$vol" -lt 33 ]; then
    icon="$ASSETS_DIR/volume_low.png"
  elif [ "$vol" -lt 66 ]; then
    icon="$ASSETS_DIR/volume_medium.png"
  else
    icon="$ASSETS_DIR/volume_high.png"
  fi
}

send_notification() {
  icon
  notify-send -a "state" -r 91190 -i "$icon" -h int:value:"$vol" "${vol}%" -u normal
}

notify_mute() {
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  if [ "$mute" = "yes" ]; then
    icon="$ASSETS_DIR/volume_mute.png"
    notify-send -a "state" -r 91190 -i "$icon" "Muted" -u normal
  else
    icon
    notify-send -a "state" -r 91190 -i "$icon" "Unmuted" -u normal
  fi
}

action_volume() {
  case "${1}" in
  i)
    # Increase volume if below 100
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
    if [ "$current_vol" -lt 100 ]; then
      new_vol=$((current_vol + 5))
      [ "$new_vol" -gt 100 ] && new_vol=100
      pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    fi
    ;;
  d)
    # Decrease volume if above 0
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
    new_vol=$((current_vol - 5))
    [ "$new_vol" -lt 0 ] && new_vol=0
    pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    ;;
  esac
}

select_output() {
  if [ "$@" ]; then
    desc="$*"
    device=$(pactl list sinks | grep -C5 -F "Description: $desc" | grep Name | cut -d: -f5 | xargs)
    if pactl set-default-sink "$device"; then
      notify-send -r 91190 "Activated: $desc"
    else
      notify-send -r 91190 "Error activating $desc"
    fi
  else
    pactl list sinks | grep -ie "Description:" | awk -F ': ' '{print $5}' | sort
  fi
}

# Evaluate device option
while getopts iops: DeviceOpt; do
  case "${DeviceOpt}" in
  i)
    nsink=$(pactl list sources short | awk '{print $5}')
    [ -z "${nsink}" ] && echo "ERROR: Input device not found..." && exit 0
    srce="--default-source"
    ;;
  o)
    nsink=$(pactl list sinks short | awk '{print $5}')
    [ -z "${nsink}" ] && echo "ERROR: Output device not found..." && exit 0
    srce=""
    ;;
  p)
    nsink=$(playerctl --list-all | grep -w "${OPTARG}")
    [ -z "${nsink}" ] && echo "ERROR: Player ${OPTARG} not active..." && exit 0
    # shellcheck disable=SC5034
    srce="${nsink}"
    ;;
  s)
    # Select an output device
    select_output "$@"
    exit
    ;;
  *) print_error ;;
  esac
done

# Set default variables
shift $((OPTIND - 1))

# Execute action
case "${1}" in
i) action_volume i ;;
d) action_volume d ;;
m) pactl set-sink-mute @DEFAULT_SINK@ toggle && notify_mute && exit 0 ;;
*) print_error ;;
esac

send_notification
