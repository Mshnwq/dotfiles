alias chmox='chmod +x'
alias dev='devenv shell $SHELL'
alias ...='cd ../..'

_OpenApps() {
  local -a options
  options=("${(@f)$(OpenApps --completion-list 2>/dev/null | cut -d: -f1)}")
  compadd -a options
}
compdef _OpenApps OpenApps
alias oa='OpenApps'

alias -s json="jless"

# Program renames
alias py='python'
alias hm='home-manager'
alias n="nvim"
alias v="vim"
alias gdl="gallery-dl"
alias ydl="yt-dlp"
alias grep='grep --color'
alias diff='diff --color'
alias kssh='kitten ssh'
alias lsblk='lsblk | bat -l conf --theme ansi -p'
alias df='df -h | bat -l conf --theme ansi -p'
alias du1="du -hd 1 . | sort -hr | sed -E 's/[0-9]+(\.[0-9]+)?[KMGTP]/\x1b[33m&\x1b[0m/g' | bat -p --tabs 8"

alias l='exa -al --icons'
alias ll='/bin/ls -alF'
alias la='exa --all --icons'
alias ls='exa --icons'
alias lg='exa --icons --git'
alias lgt='exa --icons --git --tree -L=3'
alias lt='exa --icons --tree -L=3'
alias lta='exa --all --icons --tree -L=3'

alias cat="bat --theme=base16 --paging=never"
alias cata="bat --theme=base16 --show-all --paging=never"
