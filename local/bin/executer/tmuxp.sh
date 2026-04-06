#!/usr/bin/env bash
set -euo pipefail

tmpfile=$(mktemp)
TMUXP_DIR="$HOME/.config/tmux/tmuxp"

TMPFILE=$tmpfile &&
  alacritty --class FloaTerm,ExecTerm --title=ExecTerm \
    --working-directory "$TMUXP_DIR" -e sh -c "
    source $HOME/.cache/wal/custom-fzf.sh
    ls *.yaml | sed 's|.yaml$||' | fzf \
      --preview='highlight -O ansi {}.yaml' \
      --preview-window=right:85%:wrap > $TMPFILE
  "
chosen=$(<"$tmpfile")
rm -f "$tmpfile"
[[ -n $chosen ]] && {
  tmuxp load "$TMUXP_DIR/$chosen.yaml" &
  dunstify -u low "Tmuxp loaded" "$chosen"
}
