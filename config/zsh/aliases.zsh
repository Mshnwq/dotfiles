#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘

alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias vm-on="sudo systemctl start libvirtd.service"
alias vm-off="sudo systemctl stop libvirtd.service"

alias musica="ncmpcpp"

alias sctl='systemctl'
alias svc='service'

# Program renames
alias py='python3'
alias vi="nvim"
alias ghidra="ghidraRun"
alias flt="flutter"
# ALIAS COMMANDS
alias grep='grep --color'
#alias tmux='tmux -u'

# -------------------------------------------------------------------
# List
# -------------------------------------------------------------------
alias l='/bin/ls -CF'
alias ll='/bin/ls -alF'
alias la='exa --all --icons'
alias ls='exa --icons'
alias lg='exa --icons --git'
alias lgt='exa --icons --git --tree -L=3'
alias lt='exa --icons --tree -L=3'
alias lta='exa --all --icons --tree -L=3'
alias llc='exa -al --icons'

# ----
# Cat
# ----
alias cat="bat --theme=base16 --paging=never"
alias cata="bat --theme=base16 --show-all --paging=never"

# -------------------------------------------------------------------
# Cargo
# -------------------------------------------------------------------
alias crg='cargo'
alias crgb='cargo build'
alias crgr='cargo run'

# Scripts
alias new-wall="feh --randomize --bg-fill ~/Pictures/Grey-Anime/*"
