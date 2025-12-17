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

tfpl() {
  tf plan | awk '
    {print; fflush()}
    { 
      line = $0
      # to remove ANSI so `destroy` & `replaced`
      gsub(/\x1b\[[0-9;]*m/, "", line)
      if (line ~ /# .*will be created/) {
        gsub(/.*# /, "", line);created[++c] = line
      }
      if (line ~ /# .*will be updated/) {
        gsub(/.*# /, "", line); updated[++u] = line
      }
      if (line ~ /# .*(will be destroyed|must be replaced)/) {
        gsub(/.*# /, "", line); destroyed[++d] = line
      }
    }
    END {
      if (c || u || d) {
        print ""
        if (c) { printf "\n✅ New resources:\n";        for (i=1; i<=c; i++) printf "  \033[38;2;124;179;66m+\033[0m %s\n", created[i] }
        if (u) { printf "\n🔄 Resources to update:\n";  for (j=1; j<=u; j++) printf "  \033[38;2;140;175;191m~\033[0m %s\n", updated[j] }
        if (d) { printf "\n❌ Resources to destroy:\n"; for (k=1; k<=d; k++) printf "  \033[38;2;244;67;54m-\033[0m %s\n", destroyed[k] }
        print ""
      }
    }
  '
}

alias tfin='tf init'
alias tfap='tf apply'
alias tfds='tf destroy'
alias tfrf='tf refresh'
alias tfvd='tf validate'
alias tfmt='tf fmt'
alias tfmv='tf mv'
alias tfst='tf state'
alias tfstls='tf state list'
