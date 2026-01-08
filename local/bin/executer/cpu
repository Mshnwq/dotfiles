#!/usr/bin/env bash

case $1 in
--on)
  sudo auto-cpufreq --force=performance
  sudo auto-cpufreq --turbo=always
  ;;
--off)
  sudo auto-cpufreq --force=powersave
  sudo auto-cpufreq --turbo=never
  ;;
--status)
  alacritty --option 'font.size=12' \
    --class FloaTerm,TopTerm --title=TopTerm \
    -e auto-cpufreq --stats
  ;;
esac
