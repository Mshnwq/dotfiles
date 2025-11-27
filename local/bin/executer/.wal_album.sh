#!/usr/bin/env bash
set -euo pipefail

TRACK="$(mpc --format '%file%' current)"

if [[ -z "$TRACK" ]]; then
  echo "No track playing (mpc reported empty)." >&2
  dunstify "Album Wal" "No track playing"
  exit 1
fi

OUT_DIR="$HOME/.cache/wal/album"
TRACK_FILE="$HOME/Music/$TRACK"
TRACK_DIR="$(dirname "$TRACK_FILE")"

have_cover=0

# search for folder art next to the audio file ---
if [[ $have_cover -eq 0 ]]; then
  TRACK_DIR_HASH=$(echo "$TRACK_DIR" | sha256sum | cut -d' ' -f1)
  for name in "cover.jpg" "cover.png" "front.jpg" "front.png" "AlbumArt*.jpg" "AlbumArt*.png"; do
    if [[ -f "$TRACK_DIR/$name" ]]; then
      COVER="$TRACK_DIR/$name"
      OUT="$OUT_DIR/$TRACK_DIR_HASH.png"
      have_cover=1
      break
    fi
  done
fi

# --- 2. Fallback: extract embedded cover with ffmpeg ---
if [[ $have_cover -eq 0 ]]; then
  TRACK_HASH=$(echo "$TRACK" | sha256sum | cut -d' ' -f1)
  TMP_COVER="$OUT_DIR/${TRACK_HASH}_embedded.png"
  if ffmpeg -v error -y -i "$TRACK_FILE" -an -map 0:v:0 -frames:v 1 "$TMP_COVER" 2>/dev/null; then
    if [[ -s "$TMP_COVER" ]]; then
      COVER="$TMP_COVER"
      OUT="$OUT_DIR/$TRACK_HASH.png"
      have_cover=1
    fi
  fi
fi

# --- Compose wallpaper ---
if [[ $have_cover -eq 1 ]]; then
  magick "$COVER" -resize 1920x1080\! "$OUT"
  echo "Wallpaper created: $OUT"
  WallColor $OUT
else
  echo "No cover art found"
  dunstify "Album Wal" "No cover art found"
fi
