#!/usr/bin/env bash
set -uo pipefail

readonly REMOTE_HOST_FILE="$HOME/.config/mpd_remote_host"
readonly MEDIA_CONTROL="$HOME/.local/bin/MediaControl"
readonly WAYBAR="$HOME/.local/bin/executer/waybar.sh"
ROFI_THEME="$HOME/.config/rofi/SelectorMPD.rasi"
DOTS_DIR="$HOME/.config/dots"
OPTIONS=(
  "Local"
  "Remote"
  # TODO: "VPN"
)

STATUS_FILE="$DOTS_DIR/.mpd_status"
[[ -f $STATUS_FILE ]] || : >"$STATUS_FILE"
HOST_FILE="$DOTS_DIR/.mpd_host"
[[ -f $HOST_FILE ]] || : >"$HOST_FILE"
CONF_FILE="$HOME/.config/pipewire/pipewire-pulse.conf.d/mpd-tcp.conf"
[[ -d ${CONF_FILE%/*} ]] || mkdir -p "${CONF_FILE%/*}"

_notify_daemon() {
  local host="$1"
  setsid bash &>/dev/null <<-NOTIFY_DAEMON &
	LAST_TITLE=""
	while mpc --host "$host" --port 6600 idle player &>/dev/null; do
	  TITLE=\$("$MEDIA_CONTROL" --title 2>/dev/null)
	  pgrep -x rmpc >/dev/null && continue
	  [[ \$TITLE == "Play Something" || -z \$TITLE ]] && continue
	  [[ \$TITLE != "\$LAST_TITLE" ]] && {
	    "$MEDIA_CONTROL" --notify
	    LAST_TITLE="\$TITLE"
	  }
	done
	NOTIFY_DAEMON
}

_firewall() {
  sudo firewall-cmd --zone=public "--${1}-rich-rule=rule family='ipv4' source address='$2' port protocol='tcp' port='4713' accept" 2>/dev/null || true
}

_stop() {
  local host
  "$MEDIA_CONTROL" --stop

  echo "Stopping $1"
  case $1 in
  "local") systemctl --user stop mpd.service ;;
  "remote")
    host="$(<"$REMOTE_HOST_FILE")"
    { _firewall remove "$host"; }
    [[ -f $CONF_FILE ]] && rm -f "$CONF_FILE"
    systemctl --user restart pipewire-pulse
    ;;
  esac

  : | tee "$STATUS_FILE" "$HOST_FILE" >/dev/null
  pkill -f "mpc.*idle player" 2>/dev/null || true
}

_start() {
  local mode status host
  mode="$1" && status=$(<"$STATUS_FILE")
  # Check if another mode is already running
  if [[ -n $status && $status != "$mode" ]]; then
    for opt in "${OPTIONS[@]}"; do
      if [[ ${opt,,} == "$status" ]]; then
        echo "Stop $status MPD First" >&2
        dunstify -u critical "Error" "Stop $status MPD First"
        exit 1
      fi
    done
  fi

  echo "Starting $mode"
  case $mode in
  "local") systemctl --user start mpd.service ;;
  "remote")
    host="$(<"$REMOTE_HOST_FILE")"
    cat >"$CONF_FILE" <<-EOF
pulse.cmd = [
  { cmd = "load-module" args = "module-native-protocol-tcp auth-ip-acl=$host auth-anonymous=1" }
]
EOF
    { _firewall add "$host"; }
    systemctl --user restart pipewire-pulse
    ;;
  esac

  echo "$mode" >"$STATUS_FILE"
  echo "${host:-127.0.0.1}" >"$HOST_FILE"
}

if [[ -s $STATUS_FILE ]]; then
  _stop "$(<"$STATUS_FILE")" && "$WAYBAR" --mpd
else
  dunstify -r 1001 "MPC" "Starting MPC"
  choice=$(printf '%s\n' "${OPTIONS[@]}" | rofi \
    -dmenu -no-custom -p "Host" -selected-row 0 \
    -mesg "[ Select MPD Host ]" -theme "$ROFI_THEME")
  [[ -n $choice ]] && {
    dunstify -r 1001 "MPC" "Starting $choice"
    _start "${choice,,}" && sleep 1
    host="$(<"$HOST_FILE")"
    "$WAYBAR" --mpd "$host"
    _notify_daemon "$host"
  } || dunstify -r 1001 "MPC" "Canceled" && exit 0
  # TODO: find music icon
fi
