#!/usr/bin/env bash
#INPUT_REQUIRED

set -eo pipefail

log_file="/tmp/yt_dlp_error.log"
echo "=== Session started at $(date '+%Y-%m-%d %H:%M:%S') ===" >"$log_file"
trap '[[ $? -ne 0 ]] && cat "$log_file"' EXIT

# Progress monitoring and completion handling
_run_with_progress() {
  local downloads_path="$1" && shift
  dunstify "Starting Download"

  "$@" 2>>"$log_file" |
    awk '/[0-9]+\.[0-9]+%/ {
      match($0, /[0-9]+\.[0-9]+%/);
      percent = substr($0, RSTART, RLENGTH);
      gsub("%", "", percent);
      system("dunstify -r 999 \"Download Progress\" \"Progress: " percent "%\"");
    }'

  if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
    dunstify "Download Complete" "Saved to $downloads_path"
    return 0
  else
    dunstify -u critical "Download Failed" "Check error log: $log_file"
    exit 1
  fi
}

_ytdl_vid() {
  local downloads_path url yt_args
  downloads_path="$HOME/Videos"
  [[ -n $1 ]] || exit 1
  url="$1" && shift
  [[ -d $downloads_path ]] || mkdir -p "$downloads_path"
  yt_args=(--extractor-args "youtube:player_client=default,web_safari;player_js_version=actual")
  (($# > 0)) && yt_args+=("$@")

  _run_with_progress "$downloads_path" \
    yt-dlp \
    "${yt_args[@]}" \
    -P "$downloads_path" \
    -o "%(title)s [%(id)s].%(ext)s" \
    "$url" \
    --embed-thumbnail \
    --newline
}

_ytdl_aud() {
  local downloads_path url yt_args
  downloads_path="$HOME/Downloads/YT-DLP"
  [[ -n $1 ]] || exit 1
  url="$1" && shift
  [[ -d $downloads_path ]] || mkdir -p "$downloads_path"
  yt_args=(--extractor-args "youtube:player_client=default,web_safari;player_js_version=actual")
  (($# > 0)) && yt_args+=("$@")

  # Capture file names
  local file_name title_name
  file_name=$(yt-dlp "${yt_args[@]}" --get-filename -o "%(title).80B [%(id)s]" "$url" 2>>"$log_file")
  title_name=$(yt-dlp "${yt_args[@]}" --get-filename -o "%(title)s" "$url" 2>>"$log_file")
  [[ -z $file_name || -z $title_name ]] && exit 1

  _run_with_progress "$downloads_path" \
    yt-dlp \
    "${yt_args[@]}" \
    -P "$downloads_path" \
    -o "%(title).80B [%(id)s].%(ext)s" \
    "$url" \
    -x --audio-format 'm4a' \
    --embed-thumbnail \
    --newline

  # Update metadata with exiftool
  local output_file="$downloads_path/$file_name.m4a"
  if [[ -f "$output_file" ]]; then
    exiftool -overwrite_original -title="$title_name" "$output_file" 2>>"$log_file"
    [[ $? -ne 0 ]] && dunstify -u normal "Warning" "Download successful but metadata update failed"
  else
    dunstify -u normal "Warning" "Download complete but file not found at expected location"
  fi
}

case $1 in
--video | --audio) "_ytdl_${1:2:3}" "$2" "${@:3}" ;;
esac
