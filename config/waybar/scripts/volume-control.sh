#!/usr/bin/env bash

icon() {
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $5}')

  rice="$(<"$HOME/.config/dots/.rice")"
  assets_dir="$HOME/.config/dots/rices/$rice/assets"
  if [[ $mute == "yes" ]] || ((vol == 0)); then
    icon="$assets_dir/volume_mute.png"
  elif ((vol < 33)); then
    icon="$assets_dir/volume_low.png"
  elif ((vol < 66)); then
    icon="$assets_dir/volume_medium.png"
  else
    icon="$assets_dir/volume_high.png"
  fi
}

notify_mute() {
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  if [[ $mute = "yes" ]]; then
    dunstify -r 91190 -i "$assets_dir/volume_mute.png" "Muted" -u normal
  else
    icon && dunstify -r 91190 -i "$icon" "Unmuted" -u normal
  fi
}

action_volume() {
  local val && val="$2"
  local max && max=100
  local min && min=0
  local current_vol new_vol
  current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
  if [[ $1 == "-i" ]]; then
    ((current_vol < max)) && {
      new_vol=$((current_vol > (max - val) ? max : current_vol + val))
      echo $new_vol
      pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    }
  else
    ((current_vol > min)) && {
      new_vol=$((current_vol < val ? min : current_vol - val))
      pactl set-sink-volume @DEFAULT_SINK@ "${new_vol}%"
    }
  fi
}

case $1 in
--inc) action_volume -i 5 ;;
--dec) action_volume -d 5 ;;
--mute) pactl set-sink-mute @DEFAULT_SINK@ toggle && notify_mute && exit 0 ;;
*) exit 1 ;;
esac

icon && dunstify -r 91190 -i "$icon" -h int:value:"$vol" "${vol}%" -u normal
