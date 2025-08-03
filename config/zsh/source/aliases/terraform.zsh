tf() {
  if command -v tofu >/dev/null 2>&1; then
    tofu "$@"
  elif command -v terraform >/dev/null 2>&1; then
    terraform "$@"
  else
    echo "Neither tofu nor terraform found" >&2
    return 1
  fi
}

alias tfin='tf init'
alias tfap='tf apply'
alias tfds='tf destroy'
alias tfvd='tf validate'
alias tfmt='tf fmt'
alias tfpl='tf plan'
alias tfst='tf state'
alias tfstls='tf state list'
alias tfmv='tf mv'
