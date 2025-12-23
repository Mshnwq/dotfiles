colormap() {
  for i in {0..255}; do 
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

# get date
today() { bash -c "printf 'Today is %(%A %d in %B of %Y (%r))T\n'"; }

# file into clipboard Wayland
wcat() { cat "$1" | wl-copy; }

# Function to convert hex color to RGB byte values
hex_to_rgb() {
  local hex_color="$1"
  local red_hex="${hex_color:0:2}"
  local green_hex="${hex_color:2:2}"
  local blue_hex="${hex_color:4:2}"
  local red_byte=$((16#${red_hex}))
  local green_byte=$((16#${green_hex}))
  local blue_byte=$((16#${blue_hex}))
  echo "$red_byte,$green_byte,$blue_byte"
}

# Function to echo text in the given hex color
echo_in_color() {
  local hex_color="$1"
  local text="$2"
  # Convert hex to RGB byte values
  IFS=',' read -r red green blue <<< $(hex_to_rgb "$hex_color")
  # Use ANSI escape code for 24-bit color
  echo -e "\033[38;2;${red};${green};${blue}m$text\033[0m"
}

gitd() {
  eval $(ssh-agent)
  nix run nixpkgs#expect -- "$HOME/.config/zsh/source/scripts/add_ssh.expect" "$(pass show mshnwq/github-ssh-pass)"
}

vv() {
  local configs
  configs=$(find ~/.config -maxdepth 1 -type d -name "nvim-*")
  local config
  config=$(echo "$configs" | fzf --prompt="Neovim Configs > " --height=50% --layout=reverse --border --exit-0)
  [[ -z "$config" ]] && echo "No config selected" && return
  NVIM_APPNAME="${config##*/}" nvim "$@"
}

# https://sw.kovidgoyal.net/kitty/kittens/ssh/
ssh() {
  if [ "$TERM" = "xterm-kitty" ]; then
    kitten ssh "$@"
  else
    command ssh "$@"
  fi
}

# return last dir, doesnt work as alias
-() { cd -; }

wsed() {
  local file && file=$1 && shift
  diff --color "$file" <(sed "$@" "$file")
}

# print a colorized diff
cdiff() {
  local red=$(tput setaf 1 2>/dev/null)
  local green=$(tput setaf 2 2>/dev/null)
  local cyan=$(tput setaf 6 2>/dev/null)
  local reset=$(tput sgr0 2>/dev/null)
  diff -u "$@" | awk "
  /^\-/ {
    printf(\"%s\", \"$red\");
  }
  /^\+/ {
    printf(\"%s\", \"$green\");
  }
  /^@/ {
    printf(\"%s\", \"$cyan\");
  }
  {
    print \$0 \"$reset\";
  }"
  return "${PIPESTATUS[0]}"
}

worktreed() {
  git clone --bare "$1" .git
  cd .git && git worktree add ../main main && git worktree add ../dev dev
}
