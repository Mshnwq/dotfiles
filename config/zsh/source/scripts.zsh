colormap() {
  for i in {0..255}; do 
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

# get date
today() { bash -c "printf 'Today is %(%A %d in %B of %Y (%r))T\n'"; }

# file into clipboard Wayland
wcat() { cat "$1" | wl-copy; }

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
  [[ $TERM = "xterm-kitty" ]] && {
    kitten ssh "$@"
  } || command ssh "$@"
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

imx() {
  [[ -n $1 ]] || return 1
  local lang
  case ${1#*.} in
    py) lang="python3" ;;
    sh) lang="bash" ;;
    *) return 1 ;;
  esac
  echo "#!/usr/bin/env $lang">"$1"
  chmod +x "$1"
}
