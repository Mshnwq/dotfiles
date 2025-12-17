#!/usr/bin/env bash

save_state() {
  local kind="$1"
  local state="$2"
  local filter="$3"

  hyprctl clients -j | jq -r \
    --arg kind "$kind" \
    --arg filter "$filter" \
    '.[] | select(.[$kind] == $filter) |
    {
      address: .address,
      class: .class,
      title: .title,
      workspace: .workspace.id,
      monitor: .monitor,
      floating: .floating,
      at: .at,
      size: .size
    }
  ' >"$state"

  [[ -s $state ]] && echo "[INFO] Window state saved to $state" && return 0
  echo "[ERROR] Couldn't find window with $kind '$filter'." >&2 && return 1
}

wait_for_window() {
  local kind="$1"
  local filter="$2"
  local win_id=""

  for _ in {1..3}; do
    sleep 1
    win_id=$(hyprctl clients -j | jq -r \
      --arg kind "$kind" \
      --arg filter "$filter" \
      '.[] | select(.[$kind] == $filter) | .address')
    [[ -n $win_id ]] && echo "$win_id" && return 0
  done

  echo "[ERROR] Window with $kind '$filter' not found." >&2 && return 1
}

restore_state() {
  local state="$1"
  local win_id="$2"
  [[ -z $win_id ]] && echo "[ERROR] Window ID Unbound." >&2 && return 1

  # Read state from JSON
  local workspace floating
  readarray -t at < <(jq -r '.at[]' "$state")
  readarray -t size < <(jq -r '.size[]' "$state")
  workspace=$(jq -r '.workspace' "$state")
  floating=$(jq -r '.floating' "$state")

  # Apply saved state
  [[ $floating = "false" ]] && hyprctl dispatch togglefloating "address:$win_id"
  hyprctl dispatch focuswindow "address:$win_id"
  hyprctl dispatch movetoworkspacesilent "$workspace"
  hyprctl dispatch resizewindowpixel "exact ${size[0]} ${size[1]}", "address:$win_id"
  hyprctl dispatch movewindowpixel "exact ${at[0]} ${at[1]}", "address:$win_id"

  echo "[INFO] Window restored to previous state." && return 0
}

wal:relaunch() {
  local kind=""
  local state=""
  local filter=""
  local kill_cmd=""
  local launch_cmd=""

  while (($# > 0)); do
    case "$1" in
    --kind)
      kind="$2"
      shift 2
      ;;
    --window-filter)
      filter="$2"
      state="$XDG_RUNTIME_DIR/${2,,}_state.json"
      shift 2
      ;;
    --kill-cmd)
      kill_cmd="$2"
      shift 2
      ;;
    --launch-cmd)
      launch_cmd="$2"
      shift 2
      ;;
    *)
      echo "wal:relaunch: unknown option: $1" >&2
      return 2
      ;;
    esac
  done

  [[ -z $kind || -z $filter || -z $kill_cmd || -z $launch_cmd ]] && {
    echo "wal:relaunch: missing required arguments" >&2
    echo "required: --kind --window-filter --kill-cmd --launch-cmd" >&2
    return 2
  }

  save_state "$kind" "$state" "$filter" || return 1
  eval "$kill_cmd" && eval "$launch_cmd" &
  disown
  restore_state "$state" "$(wait_for_window "$kind" "$filter")"
}
