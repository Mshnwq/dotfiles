#!/usr/bin/env bash

#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

main() {

  # Check if Kitty is running
  if ! pgrep -x kitty >/dev/null; then
    echo "No Kitty  "
    exit 0
  fi

  RATE=1
  KITTY_SOCKET="unix:/tmp/init-term-kitty.sock"

  # If no socket is found, exit
  if [[ -z "$KITTY_SOCKET" ]]; then
    echo "No Kitty Socket  "
    exit 0
  fi

  # Get the focused tab title using jq
  KITTY_TAB=$(kitty @ --to "$KITTY_SOCKET" ls | jq -r '.[] | .tabs[] | select(.is_focused) | .title')

  # Display result in Tmux status bar
  if [[ -n "$KITTY_TAB" ]]; then
    echo "${KITTY_TAB}  "
  else
    echo "No Active Tab  "
  fi
}

main
