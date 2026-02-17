#!/usr/bin/env bash
set -xeuo pipefail

# TODO: cahnge to another file
TITLE="TranTerm"
DATA_DIR="$HOME/Documents/GTT"
DST_FILE="$DATA_DIR/.dst"
REPO_DIR="$DATA_DIR/repo"
REPO="https://github.com/eeeXun/gtt"
[[ -d $DATA_DIR ]] || mkdir -p "$DATA_DIR"
[[ -s $DST_FILE ]] || echo "English" >"$DST_FILE"
[[ -d $REPO_DIR ]] || git clone "$REPO" "$REPO_DIR"
TRAN_FILE="$REPO_DIR/internal/translate/google/language.go"
LANGS_FILE="$HOME/.config/keyboard_layouts.conf"

goto_gtt() {
  local wid
  wid=$(hyprctl clients -j | jq -r --arg title "$TITLE" '
    .[] | select(.title | contains($title)) | .workspace.id' | head -n1)
  [[ -n $wid ]] && {
    hyprctl dispatch workspace "$wid"
    hyprctl dispatch focuswindow "title:$TITLE"
    return 0
  }
  return 1
}

extract_gtt() {
  local src dst date_file lang lang_dir
  ydotool key 97:1 34:1 97:0 34:0
  sleep 0.1 && src=$(wl-paste)
  ydotool key 97:1 19:1 97:0 19:0
  sleep 0.1 && dst=$(wl-paste)
  lang=$(grep -w "${1,,}" "$TRAN_FILE"| awk -F'"' '{print $2}')
  lang_dir="$DATA_DIR/$lang"
  [[ -d $lang_dir ]] || mkdir -p "$lang_dir"
  date_file="$lang_dir/$(date '+%Y-%m-%d').md"
  [[ ! -f $date_file ]] &&
    echo "| Source | Translation |" >"$date_file" &&
    echo "|--------|-------------|" >>"$date_file"
  echo "| $src | $dst |" >>"$date_file"
  echo "Saved to: $date_file"
}

select_gtt() {
  _rofi_menu() {
    printf '%s\n' "${!langs[@]}" | rofi \
      -dmenu \
      -markup-rows \
      -p "Translate Language" \
      -selected-row "$selected_index" \
      -mesg "Current Language: $active_lang" \
      -theme "$HOME/.config/rofi/Selector.rasi" \
      -theme-str 'listview { columns: 2; lines: 2; }'
  }
  local langs
  declare -A langs
  while read -r code lang; do
    [[ $code == "US" ]] && continue # THE TODO: after
    [[ -n $lang && -n $code ]] && langs["$lang"]="$code"
  done < <(cat "$LANGS_FILE" | cut -d '=' -f 1)
  ((${#langs[@]} == 0)) && {
    echo "Error: No langs defined $LANGS_FILE"
    exit 1
  }
  local active_lang selected_index
  selected_index=0
  active_lang="$1"
  for lang in "${langs[@]}"; do
    [[ $active_lang == "$lang" ]] && break
    ((++selected_index))
  done
  local selected_gtt
  selected_gtt=${ _rofi_menu; }
  [[ -n $selected_gtt ]] && {
    echo "${langs[$selected_gtt]}" > "$DST_FILE"
  }
  if pgrep -f TranTerm >/dev/null; then
    pkill -f TranTerm
    sleep 0.1
  fi
  eval "${0%/*/*}/OpenApps --translate"
}

launch_gtt() {
  gtt -src "English" -dst \
    "$(grep -w "${1,,}" "$TRAN_FILE" | awk -F'"' '{print $2}')"
}

dst="$(<"$DST_FILE")"
case $1 in
--launch) launch_gtt "$dst" ;;
--select) select_gtt "$dst" ;;
--extract)
  if goto_gtt; then
    extract_gtt "$dst"
    dunstify "GTT: Extracted"
  else
    dunstify "GTT: Not Active"
  fi
  ;;
*) exit 2 ;;
esac
