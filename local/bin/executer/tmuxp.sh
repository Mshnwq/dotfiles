#!/usr/bin/env bash

tmpfile=$(mktemp)
TMUXP_DIR="$HOME/.config/tmux/tmuxp"

TMPFILE="$tmpfile" \
  kitty --name=FloatTerm --title=FloatTerm --class=FloaTerm \
  --config ~/.config/kitty/kitty-hidden.conf -d "$TMUXP_DIR" \
  -e zsh -c '
    source "${HOME}/.cache/wal/custom-fzf.sh"
    ls *.yaml | sed 's/\.yaml$//' | fzf \
      --preview="highlight -O ansi {}.yaml" \
      --preview-window=right:85%:wrap > "${TMPFILE}"
  '
chosen=$(<"$tmpfile")
rm -f "$tmpfile"
[ -z "$chosen" ]] && exit 0
tmuxp load "$TMUXP_DIR/$chosen.yaml" &
notify-send -u low "Tmuxp loaded" "$chosen"
