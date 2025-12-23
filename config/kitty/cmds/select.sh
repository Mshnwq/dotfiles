#!/usr/bin/env bash

tabs="$( kitty @ ls | jq -r '.[]  | .tabs[]  | .title' )"
tab="$(fzf --reverse <<< "${tabs}")"
kitty @ focus-tab -m "window_title:${tab}"
