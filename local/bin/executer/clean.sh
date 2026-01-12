#!/usr/bin/env bash
export PATH="$HOME/.local/bin/executer:$PATH"

_procs() {
  for app in "${@:2}"; do
    procs.sh "--$app" "$1"
  done
}

apps=(
  "gesture"
  "ydotoold"
)

case $1 in
--on)
  _procs kill "${apps[@]}"
  compositor.sh --off
  $0 --kde
  ;;
--off)
  apps+=("dunst")
  _procs start "${apps[@]}"
  compositor.sh --on
  $0 --kde
  ;;
--status)
  apps+=("dunst")
  _procs status "${apps[@]}"
  ;;
--kde)
  apps=(
    "dolphin"
    "kactivitymanagerd"
    "kunifiedpush-distributor"
    "kded6"
    "kiod6"
    "ksecretd"
    "kwalletd"
    "wsdd"
  )
  for app in "${apps[@]}"; do
    pkill -f "$app"
  done
  ;;
esac
