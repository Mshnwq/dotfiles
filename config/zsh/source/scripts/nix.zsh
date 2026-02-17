# alias nix-shell='nix-shell --run $SHELL'
nix() {
  if [[ $1 == "develop" ]]; then
    shift
    command nix develop -c $SHELL "$@"
  else
    command nix "$@"
  fi
}

# https://github.com/nix-community/comma
,() { nix run nixpkgs#$1 -- ${@:2}; }
