#!/usr/bin/env bash
set -eo pipefail

TITLE="TranTerm"
ANKI_ADDRESS="localhost:8765"
ANKI_AUDIO_DIR="$HOME/.local/share/Anki2/$USER/collection.media"
DATA_DIR="$HOME/Documents/GTT"
DST_FILE="$DATA_DIR/.dst"
REPO_DIR="$DATA_DIR/repo"
REPO="https://github.com/eeeXun/gtt"
[[ -d $DATA_DIR ]] || mkdir -p "$DATA_DIR"
[[ -s $DST_FILE ]] || echo "English" >"$DST_FILE"
[[ -d $REPO_DIR ]] || git clone "$REPO" "$REPO_DIR"
TRAN_FILE="$REPO_DIR/internal/translate/google/language.go"
LANGS_FILE="$HOME/.config/gtt_languages"

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
  lang=$(grep -w "$1" "$TRAN_FILE"| awk -F'"' '{print $2}')
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
      -mesg "Current Language: ${active_lang^^}" \
      -theme "$HOME/.config/rofi/Selector.rasi" \
      -theme-str 'listview { columns: 2; lines: 2; }'
  }
  local langs
  declare -A langs
  while IFS='=' read -r code lang; do
    [[ -n $lang && -n $code ]] && langs["$lang"]="$code"
  done <"$LANGS_FILE" 
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
    "$(grep -w "$1" "$TRAN_FILE" | awk -F'"' '{print $2}')"
}

anki_gtt() {
  local src dst date_file lang lang_dir audio
  ydotool key 97:1 34:1 97:0 34:0
  sleep 0.1 && src=$(wl-paste)
  ydotool key 97:1 19:1 97:0 19:0
  sleep 0.1 && dst=$(wl-paste)
  audio="$ANKI_AUDIO_DIR/${dst}.mp3"
  ydotool key 97:1 25:1 97:0 25:0
  sleep 0.1
  # https://www.reddit.com/r/archlinux/comments/x2kej0/recording_output_audio_using_pipewire/
  pw-record -P '{ stream.capture.sink=true }' --format s16 --rate 44100 --channels 2 - | \
    ffmpeg -f s16le -ar 44100 -ac 2 -i pipe:0 \
      -af "silenceremove=start_periods=1:start_silence=0.1:start_threshold=-50dB,silenceremove=stop_periods=-1:stop_duration=0.5:stop_threshold=-50dB" \
      -acodec mp3 "$audio" &
  # local ffmpeg_pid=$!
  # ( sleep 8; pkill -x pw-record ) &
  # local safety_pid=$!
  # wait $ffmpeg_pid
  # kill $safety_pid 2>/dev/null
  # pkill -x pw-record 2>/dev/null
  # TODO: have it autodetect a silence and stop
  # Monitor the audio levels and stop recording once silence over 2 secods is detected
  # tee > stream to 2 ffmpegs 1 record, 1 detects silnce
  sleep 8
  pkill -x pw-record
  sleep 1
  # make a copy incase
  lang=$(grep -w "$1" "$TRAN_FILE"| awk -F'"' '{print $2}')
  lang_dir="$DATA_DIR/Anki/$lang"
  [[ -d $lang_dir ]] || mkdir -p "$lang_dir"
  cp "$audio" "$lang_dir/${src}|${dst}.mp3"
  # https://github.com/FooSoft/anki-connect/issues/95
  jq -n \
    --arg src "$src" \
    --arg dst "$dst" '{
    action: "addNote",
    version: 5,
    params: {
      note: {
        deckName: "Learning",
        modelName: "Basic",
        fields: {
          Front: $src,
          Back: ($dst + " [sound:" + $dst + ".mp3]")
        },
        tags: ["gtt"]
      }
    }
  }' | curl "$ANKI_ADDRESS" -X POST -d @- | jq
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
--anki)
  if goto_gtt; then
    anki_gtt "$dst"
    dunstify "GTT: Ankied"
  else
    dunstify "GTT: Not Active"
  fi
  ;;
*) exit 2 ;;
esac
