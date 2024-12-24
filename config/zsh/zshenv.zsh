# Add directory to your PATH  .
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
source $HOME/.cargo/env

# VENV to PATH
export PATH="$PATH:$VIRTUAL_ENV"
export PATH="$PATH:$JAVA_HOME/bin"

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# GVM (GO version Manager)
source "$HOME/.gvm/scripts/gvm"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PNPM 
export PNPM_HOME="/home/mshnwq/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# TMUXP PATH
export TMUXP_CONFIGDIR="$HOME/.tmux/tmuxp"
# AZURE 
export PATH="$PATH:$HOME/.azure/bin"

# PERL
PATH="/home/mshnwq/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/mshnwq/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mshnwq/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mshnwq/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mshnwq/perl5"; export PERL_MM_OPT;

# QT5
#export QT_SCALE_FACTOR=1.25
export QT_QPA_PLATFORMTHEME="qt5ct"
