#!/bin/bash

gpu_commands() {
  nvidia-smi -l
  echo "Mounted. Press Enter to close..."
  read
}

export -f gpu_commands
alacritty --option 'font.size=14' \
  --class FloaTerm,TopTerm --title=TopTerm \
  -e bash -c "bash -i -c gpu_commands"
