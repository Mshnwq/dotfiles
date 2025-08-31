#!/usr/bin/env bash

export PATH="$HOME/.config/dots/scripts/executer:$PATH"

get_state() {
  .mpd_status.sh --quiet
}

disable_mpc() {
  TYPE=$(cat "$HOME/.config/dots/.mpd_status")
  ".mpd_${TYPE}_stop.sh"
  pkill -f mpc
  ".waybar_mpd.sh"
}

enable_mpc() {
  notify-send "MPC" "Starting MPC"

  ROFI_THEME="$HOME/.config/rofi/SelectorMPD.rasi"
  # Define the options
  # local options=("Local" "Remote" "Remote VPN")
  local options=("Local" "Remote" "Remote VPN")
  # Show Rofi menu and get the user's choice
  CHOICE=$(printf '%s\n' "${options[@]}" | rofi -theme "$ROFI_THEME" -mesg "[ Select MPD Host ]" -dmenu -no-custom -p "Host" -selected-row 0) 
  MPD_HOST="/home/mshnwq/.config/dots/.mpd_host"

  # Handle the selection
  case "$CHOICE" in
    "Local")
      notify-send "MPC" "Starting Local"
      .mpd_local_start.sh
      .waybar_mpd.sh "$(<"$MPD_HOST")"
      sleep 1
      .mpc_notify.sh
      ;;
    "Remote")
      notify-send "MPC" "Starting Remote"
      .mpd_remote_start.sh
      .waybar_mpd.sh "$(<"$MPD_HOST")"
      sleep 2
      .mpc_notify.sh
      ;;
    "Remote VPN")
      notify-send "MPC" "Starting Remote VPN"
      # TODO: optimize
      # .mpd_remote_vpn_start.sh
      ;;
    *)
      exit 1
      ;;
  esac
}

toggle() {
	if [[ $(get_state) == "on" ]]; then
		disable_mpc
	else
		enable_mpc
	fi
}

arg="${1:-toggle}"
case $arg in
    state) get_state ;;
    toggle) toggle ;;
esac

