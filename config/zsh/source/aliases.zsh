#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘

alias chmox='chmod +x'
alias dev='devenv shell $SHELL'
alias ...='cd ../..'

# Program renames
alias py='python'
alias hm='home-manager'
alias n="nvim"
alias v="vim"
alias gdl="gallery-dl"
alias ydl="yt-dlp"
# ALIAS COMMANDS
alias lsblk='lsblk | bat -l conf --theme ansi -p'
alias grep='grep --color'
#alias tmux='tmux -u'

# -------------------------------------------------------------------
# List
# -------------------------------------------------------------------
#alias l='/bin/ls -CF'
alias ll='/bin/ls -alF'
alias la='exa --all --icons'
alias ls='exa --icons'
alias lg='exa --icons --git'
alias lgt='exa --icons --git --tree -L=3'
alias lt='exa --icons --tree -L=3'
alias lta='exa --all --icons --tree -L=3'
#alias llc='exa -al --icons'
alias l='exa -al --icons'

# ----
# Cat
# ----
alias cat="bat --theme=base16 --paging=never"
alias cata="bat --theme=base16 --show-all --paging=never"
