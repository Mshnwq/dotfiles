#!/usr/bin/env bash

WINDOW_TITLE="Obsidian"

if hyprctl clients -j | jq -e --arg title "$WINDOW_TITLE" '.[] | select(.title | contains($title))' >/dev/null; then
    echo "refreshing obsidian"
    xdg-open "obsidian://adv-uri?vault=Home&commandid=obsidian-pywal-theme%3Areload-pywal-theme"
else
    echo "not running obsidian"
fi
