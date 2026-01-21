#!/usr/bin/env bash
set -eo pipefail
export PATH="$HOME/.local/bin/executer:$HOME/.local/bin:$PATH"

# TODO: do the fg <> pipe from advacned ysap to watch over the sub wal's
LOG_FILE="$HOME/.cache/wal/wall_color.log"
KITTY_CONF="$XDG_CONFIG_HOME/kitty/kitty.conf"
TMUX_SOCKET="$XDG_RUNTIME_DIR/init-term-kitty.sock"
NIX_SHELL_CURSOR=(
  "nix-shell"
  "-I nixpkgs=https://github.com/nixos/nixpkgs/archive/master.tar.gz"
  "--run"
  "just build mocha pywal"
)
WALL="$HOME/.config/dots/rices/.wall"
[[ -f $WALL ]] || exit 1

wallpaper_path="$(<"$WALL")"
builddir=$(<"$HOME/.config/builddir")
builddir="${builddir/#\~/$HOME}"

COLORS="$HOME/.cache/wal/colors.sh"
# shellcheck disable=SC1091
# shellcheck source=$COLORS
[[ -f "$COLORS" ]] && source "$COLORS"

# validate
[[ -d "${LOG_FILE%/*}" ]] || mkdir -p "${LOG_FILE%/*}"
echo "=== Wal Color Apply Start: $(date '+%F %T') ===" >"$LOG_FILE"

log() { echo "[$(date '+%T')] INFO: $*" | tee -a "$LOG_FILE" >/dev/null; }
error() { echo "[$(date '+%T')] ERROR: $*" | tee -a "$LOG_FILE" >&2; }

_relaunch() {
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

_rmpc() {
  _relaunch \
    --kind title \
    --kill-cmd "pkill rmpc" \
    --window-filter "MusicTerm" \
    --launch-cmd "OpenApps --music"
}

_yazi() {
  _relaunch \
    --kind title \
    --window-filter "FileTerm" \
    --launch-cmd "OpenApps --yazi-tmux-last" \
    --kill-cmd "ya emit-to \"$(<"$HOME/.config/dots/.yazi_id")\" plugin projects quit && tmux kill-session -t yazi"
}

_btop() {
  _relaunch \
    --kind title \
    --kill-cmd "pkill btop" \
    --window-filter "TopTerm" \
    --launch-cmd "OpenApps --top"
}

_qbit() {
  cd "$builddir/qbittorrent" &&
    nix-shell -p libsForQt5.qt5.qtbase --run "just compile"
  cd - || exit 1
  _relaunch \
    --kind class \
    --kill-cmd "pkill -f qbittorrent" \
    --window-filter "org.qbittorrent.qBittorrent" \
    --launch-cmd "gtk-launch org.qbittorrent.qBittorrent"
}

_telegram() {
  # https://legacy.imagemagick.org/Usage/blur/#blur_args.
  wal-telegram --wal -d "$HOME/.cache/wal" -g 1x1
  _relaunch \
    --kind class \
    --kill-cmd "pkill -f Telegram" \
    --window-filter "org.telegram.desktop" \
    --launch-cmd "flatpak run org.telegram.desktop"
}

_tmux() {
  [[ -S $TMUX_SOCKET ]] && tmux \
    source-file "$HOME/.config/tmux/tmux.conf"
}

_obsidian() {
  hyprctl clients -j | jq -e --arg title "Obsidian" '.[] | select(.title | contains($title))' &&
    xdg-open "obsidian://adv-uri?vault=Home&commandid=obsidian-pywal-theme%3Areload-pywal-theme"
}

_kitten() { kitten @ --to unix:"$1" "${@:2}"; }
_kitty_sockets() {
  local callback="$1" cmd="$2"
  for socket in "$XDG_RUNTIME_DIR"/kitty_socket-*; do
    [[ -S $socket ]] && "$callback" "$socket" "$cmd"
  done
}

_kitty() {
  # shellcheck disable=SC2329
  _callback() { _kitten "$1" "$2"; }
  local cmd=("load-config" "$KITTY_CONF")
  _kitty_sockets _callback "${cmd[@]}"
  [[ -S $TMUX_SOCKET ]] &&
    _kitten "$TMUX_SOCKET" "${cmd[@]}"
}

_p10k() {
  # shellcheck disable=SC2329
  _callback() {
    local socket command && socket="$1" command="$2"
    local json && json=$(kitten @ --to "unix:$socket" ls)
    echo "$json" | jq -c '.[] | .tabs[]?.windows[]? |
      {id: .id, foreground_processes: .foreground_processes}' |
      while IFS= read -r window; do
        local fg_count fg_cmd win_id
        fg_count=$(echo "$window" |
          jq '.foreground_processes | length')
        ((fg_count == 1)) || continue
        fg_cmd=$(echo "$window" |
          jq -r '.foreground_processes[0].cmdline[0]')
        [[ $fg_cmd == *"zsh" ]] || continue
        win_id=$(echo "$window" | jq -r '.id')
        _kitten "$socket" send-text \
          --match "id:$win_id" "$command"$'\r'
      done
  }

  local p10k_file="$HOME/.config/zsh/.p10k.zsh"
  local p10k_theme="$HOME/.cache/wal/custom-p10k.sh"
  local command="source $p10k_file; clear"
  local theme_block

  sed -i '/# -- start replace from rice/,/# -- end replace from rice/{
    /# -- start replace from rice/!{/# -- end replace from rice/!d}
  }' "$p10k_file"

  theme_block="$(<"$p10k_theme")"
  awk -v block="$theme_block" '
    BEGIN { in_block = 0 }
    {
      if ($0 ~ /# -- start replace from rice/) {
        print $0
        print block
        in_block = 1
        next
      }
      if ($0 ~ /# -- end replace from rice/) {
        in_block = 0
      }
      if (!in_block) {
        print $0
      }
    }
  ' "$p10k_file" >"${p10k_file}.tmp" &&
    mv "${p10k_file}.tmp" "$p10k_file"

  _kitty_sockets _callback "$command"
  [[ -S $TMUX_SOCKET ]] && {
    while read -r pane app; do
      [[ $app == "zsh" ]] && tmux send-keys -t "$pane" "$command" C-m
    done < <(tmux list-panes -a -F "#{pane_id} #{pane_current_command}")
  }
}

_nvchad() {
  local nvchad_file="$HOME/.config/nvim/lua/chadrc_pywal.lua"
  local nvchad_theme="$HOME/.cache/wal/custom-nvchad.sh"
  local chadwal_theme="$HOME/.cache/wal/base46-dark.lua"
  local base46_theme="$HOME/.local/share/nvim/lazy/base46/lua/base46/themes/chadwal.lua"

  [[ -f $chadwal_theme ]] && cp "$chadwal_theme" "$base46_theme"
  sed -i '/  -- start replace from rice/,/  -- end replace from rice/{
    /  -- start replace from rice/!{/  -- end replace from rice/!d}
  }' "$nvchad_file"

  local theme_block
  theme_block="$(<"$nvchad_theme")"
  awk -v block="$theme_block" '
  BEGIN { in_block = 0 }
  {
    if ($0 ~ /  -- start replace from rice/) {
      print $0
      print block
      in_block = 1
      next
    }
    if ($0 ~ /  -- end replace from rice/) {
      in_block = 0
    }
    if (!in_block) {
      print $0
    }
  }
' "$nvchad_file" >"${nvchad_file}.tmp" &&
    mv "${nvchad_file}.tmp" "$nvchad_file"

  for addr in "$XDG_RUNTIME_DIR"/nvim.*; do
    nvim --server "$addr" --remote-send \
      ':lua require("nvchad.utils").reload() <cr>' ||
      touch "$HOME/.cache/wal/nvim_reload"
  done
}

_plasma() {
  local pywal_dir papirus_dir
  pywal_dir="$HOME/.cache/wal/Papirus/Pywal"
  papirus_dir="$HOME/.local/share/icons/Papirus"

  while read -r src; do
    rel_path="${src#"${pywal_dir}"/}"
    dest="${papirus_dir}/${rel_path}"
    [[ -f $dest ]] && cp -f "$src" "$dest"
    # [[ -d ${dest%/*} ]] || mkdir -p "${dest%/*}"
    # printf "%s -> %s\n" "$src" "$dest"
  done < <(find "$pywal_dir" -type f -path "*/places/*.svg")

  papirus-folders -C cat-mocha-pywal --theme Papirus-Dark
  plasma-apply-colorscheme BreezeDark
  plasma-apply-colorscheme Pywal
}

_dunst() {
  local rice assets_dir
  [[ -n "$color4" ]] || return 1
  rice=$(<"$HOME/.config/dots/.rice")
  assets_dir="$HOME/.config/dots/rices/$rice/assets"

  # Generate notification icons with ImageMagick
  local -A icons=(
    ["brightness.png"]=""
    ["volume_high.png"]="󰕾"
    ["volume_medium.png"]="󰖀"
    ["volume_low.png"]="󰕿"
    ["volume_mute.png"]="󰝟"
  )

  for icon in "${!icons[@]}"; do
    magick -pointsize 64 -size 64x64 xc:transparent \
      -fill "${color4}" -font 'JetBrainsMono-NF-ExtraBold' \
      -draw "gravity center text 0 0 '${icons[$icon]}'" "$assets_dir/$icon"
  done

  # Update lock icon colors
  for svg in locked.svg unlocked.svg; do
    [[ -f "$assets_dir/$svg" ]] &&
      sed -i "s/color:#.*/color:$color4; }/" "$assets_dir/$svg"
  done

  procs.sh --dunst start
}

_waybar() {
  [[ -n "$cursor" ]] &&
    sed -i "/\/\/-clock-date/s|\"<span color='#.*'><b>{}</b></span>\"|\"<span color='${cursor}'><b>{}</b></span>\"|" "$HOME/.config/waybar/config.jsonc" && waybar.sh --start
}

_sddm() {
  # variables
  local sddm_simple="/opt/sddm/themes/simple_sddm_2"
  local sddm_theme_conf="$sddm_simple/theme.conf"
  local colors_wallust="$HOME/.cache/wal/colors.css"

  # Extract colors
  local -A colors
  for i in 0 10 12 13 14; do
    colors[$i]=$(grep -oP "color$i:\s*\K#[A-Fa-f0-9]+" "$colors_wallust")
  done

  # Update the colors in the SDDM config
  sudo sed -i \
    -e "s/HeaderTextColor=\"#[0-9A-Fa-f]\{6\}\"/HeaderTextColor=\"${colors[13]}\"/" \
    -e "s/DateTextColor=\"#[0-9A-Fa-f]\{6\}\"/DateTextColor=\"${colors[13]}\"/" \
    -e "s/TimeTextColor=\"#[0-9A-Fa-f]\{6\}\"/TimeTextColor=\"${colors[13]}\"/" \
    -e "s/DropdownSelectedBackgroundColor=\"#[0-9A-Fa-f]\{6\}\"/DropdownSelectedBackgroundColor=\"${colors[13]}\"/" \
    -e "s/SystemButtonsIconsColor=\"#[0-9A-Fa-f]\{6\}\"/SystemButtonsIconsColor=\"${colors[13]}\"/" \
    -e "s/SessionButtonTextColor=\"#[0-9A-Fa-f]\{6\}\"/SessionButtonTextColor=\"${colors[13]}\"/" \
    -e "s/VirtualKeyboardButtonTextColor=\"#[0-9A-Fa-f]\{6\}\"/VirtualKeyboardButtonTextColor=\"${colors[13]}\"/" \
    -e "s/HighlightBackgroundColor=\"#[0-9A-Fa-f]\{6\}\"/HighlightBackgroundColor=\"${colors[12]}\"/" \
    -e "s/LoginFieldTextColor=\"#[0-9A-Fa-f]\{6\}\"/LoginFieldTextColor=\"${colors[12]}\"/" \
    -e "s/PasswordFieldTextColor=\"#[0-9A-Fa-f]\{6\}\"/PasswordFieldTextColor=\"${colors[12]}\"/" \
    -e "s/DropdownBackgroundColor=\"#[0-9A-Fa-f]\{6\}\"/DropdownBackgroundColor=\"${colors[0]}\"/" \
    -e "s/HighlightTextColor=\"#[0-9A-Fa-f]\{6\}\"/HighlightTextColor=\"${colors[10]}\"/" \
    -e "s/PlaceholderTextColor=\"#[0-9A-Fa-f]\{6\}\"/PlaceholderTextColor=\"${colors[14]}\"/" \
    -e "s/UserIconColor=\"#[0-9A-Fa-f]\{6\}\"/UserIconColor=\"${colors[14]}\"/" \
    -e "s/PasswordIconColor=\"#[0-9A-Fa-f]\{6\}\"/PasswordIconColor=\"${colors[14]}\"/" \
    "$sddm_theme_conf"

  # Copy wallpaper to SDDM theme
  sudo cp "$wallpaper_path" "$sddm_simple/Backgrounds/default"
}

_album() {
  local track track_file track_dir track_dir_hash
  local out out_dir cover have_cover tmp_cover

  track="$(MediaControl --file)"
  [[ -n $track ]] || {
    echo "No track playing (mpc reported empty)." >&2
    dunstify "Album Wal" "No track playing"
    exit 1
  }
  out_dir="$HOME/.cache/wal/album"
  track_file="$HOME/Music/$track"
  track_dir="${track_file%/*}"

  have_cover=0
  # search for folder art next to the audio file ---
  track_dir_hash=$(echo "$track_dir" | sha256sum | cut -d' ' -f1)
  covers=(
    "cover.jpg"
    "cover.png"
    "front.jpg"
    "front.png"
    "AlbumArt*.jpg"
    "AlbumArt*.png"
  )
  for name in "${covers[@]}"; do
    [[ -f "$track_dir/$name" ]] && {
      cover="$track_dir/$name"
      out="$out_dir/$track_dir_hash.png"
      have_cover=1 && break
    }
  done

  # --- 2. Fallback: extract embedded cover with ffmpeg ---
  ((!have_cover)) && {
    track_hash=$(echo "$track" | sha256sum | cut -d' ' -f1)
    tmp_cover="$out_dir/${track_hash}_embedded.png"
    if ffmpeg -y -i "$track_file" -v \
      error -an -map 0:v:0 -frames:v 1 \
      "$tmp_cover" 2>/dev/null &&
      [[ -s $tmp_cover ]]; then
      cover="$tmp_cover"
      out="$out_dir/$track_hash.png"
      have_cover=1
    fi
  }

  # --- Compose wallpaper ---
  # shellcheck disable=SC2015
  ((have_cover)) && {
    magick "$cover" -resize 1920x1080\! "$out"
    echo "$out" >"$WALL" && $0 --all --wait
  } || dunstify "Album Wal" "No cover art found"
}

_cursors() {
  local cursor_dir="$builddir/cursors"
  local cursor_file="$cursor_dir/src/templates/svgs.tera"
  local cache_dir="$HOME/.cache/wal/cursors"
  [[ -f "$cursor_file" ]] || exit 1

  local cache_path name
  if [[ $1 == "--soy" ]]; then
    name="soy"
    cache_path="$cache_dir/soy-$(echo "$wallpaper_path" | sha256sum | cut -d' ' -f1)"
  else
    name="default"
    cache_path="$cache_dir/$(echo "$wallpaper_path" | sha256sum | cut -d' ' -f1)"
  fi

  # Replace FF0000 with pywal color3 in cursor template
  [[ -n "$color3" ]] &&
    sed -i -E 's|(replace\(from="FF0000", to=")[^"]*(")|\1'"${color3#\#}"'\2|' "$cursor_file"

  # Use cached build if available
  if [[ -d $cache_path ]]; then
    log "Using cached cursor build"
    rm -r "$cursor_dir/dist/"
    cp -r "$cache_path/" "$cursor_dir/dist/"
  else
    log "Building new cursor theme"
    cd "$cursor_dir" && cp \
      "$cursor_dir/src/$name.svg" \
      "$cursor_dir/src/svgs/default.svg"
    if "${NIX_SHELL_CURSOR[@]}"; then
      log "Build successful. Saving to cache."
      mkdir -p "$cache_path"
      cp -r "$cursor_dir/dist/catppuccin-mocha-pywal-cursors" "$cache_path"
    else
      error "Build failed. Cache not created."
      return 1
    fi
  fi

  hyprctl setcursor 'Catppuccin Mocha Pywal' 18
}

_cursor() { _cursors; }
_wojak() { _cursors --soy; }

_color() {
  local theme="$1"
  local pid_file="/tmp/wal_${theme}.pid"
  log "Starting $theme (background)"

  (
    if "_$theme" >>"$LOG_FILE" 2>&1; then
      log "Finished $theme (success)"
    else
      error "Failed $theme (exit code: $?)"
    fi
    rm -f "$pid_file"
  ) &

  local pid=$!
  echo "$pid" >"$pid_file"
  log "$theme launched with PID: $pid"
}

auto=(
  # slowest
  "cursor"
  "plasma"
  "tmux"
  # priority
  "kitty"
  "p10k"
  "dunst"
  "waybar"
  "nvchad"
  "btop"
  "yazi"
  "rmpc"
  "qbit"
  "telegram"
  "obsidian"
  "sddm"
)

manual=(
  "album"
  "wojak"
)

# TODO: fix exit code
case $1 in
--get) echo "${auto[@]}" "${manual[@]}" ;;
--theme) [[ $2 =~ ^($(printf '%s|' "${auto[@]}" "${manual[@]}"))$ ]] && "_$2" ;;
--all)
  log "Running wal..."
  if wal -sti "$wallpaper_path" 2>&1 | tee -a "$LOG_FILE"; then
    log "wal completed successfully"
  else
    error "wal command failed or timed out (exit: $?)"
    exit 1
  fi

  COLORS="$HOME/.cache/wal/colors.sh"
  # shellcheck disable=SC1091
  # shellcheck source=$COLORS
  [[ -f "$COLORS" ]] &&
    source "$COLORS" &&
    log "Loaded colors from $COLORS"

  for theme in "${auto[@]}"; do
    _color "$theme"
  done
  log "All themes launched in background"

  [[ $2 == "--wait" ]] && {
    log "Waiting for all themes..."
    pids=(/tmp/wal_*.pid)

    while [[ -e "${pids[0]}" ]]; do
      sleep 0.5 && pids=(/tmp/wal_*.pid)
    done

    dunstify "Wall Color" "All Themes Completed"
  }
  ;;
esac
