#!/usr/bin/env bash

gpu_commands() {
  nvtop
}

export -f gpu_commands
alacritty --option 'font.size=12' \
  --class FloaTerm,TopTerm --title=TopTerm \
  -e bash -c "bash -ic gpu_commands"
