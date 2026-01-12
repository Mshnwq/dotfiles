#!/usr/bin/env bash

case $1 in
--on)
  "$HOME/.config/kitty/cmds/opacity.sh" --on
  "$HOME/.config/alacritty/cmds/opacity.sh" --on
  "$HOME/.config/hypr/scripts/fancy.sh" --on
  ;;
--off)
  "$HOME/.config/kitty/cmds/opacity.sh" --off
  "$HOME/.config/alacritty/cmds/opacity.sh" --off
  "$HOME/.config/hypr/scripts/fancy.sh" --off
  ;;
esac
