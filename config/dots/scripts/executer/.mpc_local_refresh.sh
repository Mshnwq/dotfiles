#!/usr/bin/env bash

cd "$HOME/Music" || exit 1

mpc clear
mpc update

# Wait briefly to ensure MPD finishes updating
sleep 2

# Recursively find and add all .m4a files relative to music dir
find . -type f -name '*.m4a' | sed 's|^\./||' | while read -r song; do
  mpc add "$song"
done
