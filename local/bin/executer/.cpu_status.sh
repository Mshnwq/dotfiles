#!/usr/bin/env bash

alacritty --option 'font.size=12' \
  --class FloaTerm,TopTerm --title=TopTerm \
  -e auto-cpufreq --stats
