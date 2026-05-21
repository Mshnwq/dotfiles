#!/usr/bin/env bash

case $1 in
--on)
  "$HOME/.config/kitty/cmds/opacity.sh" --on
  "$HOME/.config/alacritty/cmds/opacity.sh" --on
  "$HOME/.config/hypr/scripts/fancy.sh" --true
  ;;
--off)
  "$HOME/.config/kitty/cmds/opacity.sh" --off
  "$HOME/.config/alacritty/cmds/opacity.sh" --off
  "$HOME/.config/hypr/scripts/fancy.sh" --false
  ;;
esac
