#!/usr/bin/env bash
#INPUT_REQUIRED

set -euo pipefail

# Default configuration
default_downloads_path="$HOME/Downloads/YT-DLP"
log_file="/tmp/yt_dlp_error.log"

# Functions for error messages
error_exit() {
  dunstify -u critical "Error" "$1"
  echo "$1" >&2
  exit 1
}

# Check for input argument
if [[ -z "$1" ]]; then
  error_exit "No link provided for download. Usage: $0 <URL> [--use-browser-cookies]"
fi

# Assign arguments
url="$1"
downloads_path="$default_downloads_path"
use_browser_cookies="$2"

# Ensure the downloads directory exists
mkdir -p "$downloads_path" || error_exit "Failed to create downloads directory: $downloads_path."

# Notify that the download is starting
dunstify "Starting Download" "$url"

# Common yt-dlp options
yt_dlp_common_args=(--extractor-args "youtube:player_client=default,web_safari;player_js_version=actual")

if [[ "$use_browser_cookies" == "--use-browser-cookies" ]]; then
  yt_dlp_common_args+=(--cookies-from-browser firefox)
fi

# Capture the file name using yt-dlp --get-filename
file_name=$(yt-dlp "${yt_dlp_common_args[@]}" --get-filename -o "%(title)s [%(id)s]" "$url" 2>>"$log_file")
title_name=$(yt-dlp "${yt_dlp_common_args[@]}" --get-filename -o "%(title)s" "$url" 2>>"$log_file")

if [[ -z "$file_name" ]]; then
  error_exit "Failed to retrieve file name. Check log: $log_file"
fi

# Build yt-dlp command
yt_dlp_cmd=(
  yt-dlp
  "${yt_dlp_common_args[@]}"
  -P "$downloads_path"
  -o "%(title)s [%(id)s].%(ext)s"
  "$url"
  -x --audio-format 'm4a'
  --embed-thumbnail
  --newline
)

# Run yt-dlp with progress monitoring
"${yt_dlp_cmd[@]}" 2>"$log_file" |
  awk '/[0-9]+\.[0-9]+%/ {
      match($0, /[0-9]+\.[0-9]+%/);
      percent = substr($0, RSTART, RLENGTH);
      gsub("%", "", percent);
      system("dunstify -r 999 \"Download Progress\" \"Progress: " percent "%\"");
  }'

# Capture exit status of yt-dlp (not awk)
exit_status=${PIPESTATUS[0]}

# Check if yt-dlp exited successfully
if [[ $exit_status -eq 0 ]]; then
  dunstify "Download Complete" "Saved to $downloads_path"

  # Update metadata with exiftool
  output_file="$downloads_path/$file_name.m4a"
  if [[ -f "$output_file" ]]; then
    exiftool -overwrite_original -title="$title_name" "$output_file" 2>>"$log_file"
    if [[ $? -ne 0 ]]; then
      dunstify -u normal "Warning" "Download successful but metadata update failed"
    fi
  else
    dunstify -u normal "Warning" "Download complete but file not found at expected location"
  fi
else
  dunstify -u critical "Download Failed" "Check error log: $log_file"
  cat "$log_file" >&2
  exit 1
fi
