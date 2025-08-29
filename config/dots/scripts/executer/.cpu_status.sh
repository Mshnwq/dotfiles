#!/bin/bash

cpu_commands() {
  auto-cpufreq --stats
  echo "Mounted. Press Enter to close..."
  read
}

export -f cpu_commands
alacritty --option 'font.size=14' \
  --class FloaTerm,TopTerm --title=TopTerm \
  -e bash -c "bash -i -c cpu_commands"
