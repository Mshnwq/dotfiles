#!/usr/bin/env bash
#INPUT_REQUIRED

venv_path="$HOME/.local/venv/yt"
default_downloads_path="$HOME/Videos"
log_file="/tmp/yt_dlp_error.log" # Log file for errors

# Functions for error messages
error_exit() {
  dunstify -u critical "Error" "$1"
  echo "$1" >&2
  exit 1
}

# Check for input argument
if [[ -z "$1" ]]; then
  error_exit "No link provided for download. Usage: $0 <URL>"
fi

# Assign arguments
url="$1"
downloads_path="${2:-$default_downloads_path}" # Use second argument if provided, otherwise default

source "$venv_path/bin/activate"

# Ensure the downloads directory exists
mkdir -p "$downloads_path" || error_exit "Failed to create downloads directory: $downloads_path."

# Notify that the download is starting
dunstify "Starting Download" "$url"

# Monitor progress and send notifications
yt-dlp -P "$downloads_path" "$1" --embed-thumbnail --newline 2>"$log_file" |
  awk '/[0-9]+\.[0-9]+%/ {
      gsub("%", "", $0);
      print $0;
      system("dunstify -r 999 \"Download Progress\" \"Progress: " $0 "%\"");
  }'

# Check if yt-dlp exited successfully
if [[ $? -eq 0 ]]; then
  dunstify "Download complete" "Saved to $downloads_path"
else
  dunstify -u critical "Download failed" "Check error log: $log_file"
  cat "$log_file" >&2
  exit 1
fi
