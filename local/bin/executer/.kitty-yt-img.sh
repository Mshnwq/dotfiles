#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

name="$PPID"

yt-dlp --skip-download --write-thumbnail -P /tmp -o "$name" "$1"

# Detect terminal dimensions
dims="$(tput cols)x$(tput lines)@0x0"

clear
kitty +kitten icat --clear
kitty +kitten icat --hold --scale-up --place "$dims" "/tmp/$name.webp"
clear
