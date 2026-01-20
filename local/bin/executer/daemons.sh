#!/usr/bin/env bash
set -euo pipefail

_stop() { _action "stop" "$1"; }
_start() { _action "start" "$1"; }
_action() { sudo systemctl "$1" "$2.service"; }
_status() { dunstify -u low "${1^} status" "$(systemctl is-active "$1".service)"; }

actions=(
  "stop"
  "start"
  "status"
)

(($# == 0)) || [[ ! $2 =~ ^($(printf '%s|' "${actions[@]}"))$ ]] && exit 2
app="${1##--}" && action="$2"

case $1 in
# --tailscaled | --syncthing)
--tailscaled)
  { "_$action" "$app"; }
  ;;
--bluetooth)
  { "_$action" "$app"; }
  [[ $action =~ ^(${actions[0]}|${actions[1]})$ ]] && "${0%/*}/waybar.sh" "$1" "$2"
  ;;
--virtd)
  _virtd() {
    local action && action="$1"
    sudo systemctl "$action" libvirtd.service
    for drv in log lock qemu interface network nodedev nwfilter secret storage; do
      sudo systemctl "$action" virt${drv}d.service
      sudo systemctl "$action" virt${drv}d{,-ro,-admin}.socket
    done
    [[ $action == "${actions[1]}" ]] && virsh net-start default
  }
  [[ $action =~ ^(${actions[0]}|${actions[1]})$ ]] && _virtd "$action"
  ;;
esac
