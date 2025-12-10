#!/usr/bin/env bash

cpu_commands() {
  auto-cpufreq --stats
  echo "Mounted. Press Enter to close..."
  read -r
}

export -f cpu_commands
alacritty --option 'font.size=12' \
  --class FloaTerm,TopTerm --title=TopTerm \
  -e bash -c "bash -ic cpu_commands"
