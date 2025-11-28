# programs/zsh/config.nix
{
  config,
  pkgs,
  lib,
  ...
}:
# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
let
  # FOR DEBUG
  zshConfigBefore = lib.mkBefore ''
    # Profiling via:
    # https://kev.inburke.com/kevin/profiling-zsh-startup-time/
    # https://esham.io/2018/02/zsh-profiling
    # Run this to get a profile trace and exit: time zsh -i -c echo
    # ``` 
    # time PROFILE_STARTUP=true /bin/zsh -i --login -c echo 
    # ```
    # then 
    # ```
    # grep -F .zshrc: zsh_profile.xx | awk -f .zsh.awk | sort -n -r | head
    # ```
    # rm ~/zsh_profile.*
    # PROFILE_STARTUP=true /bin/zsh -i --login -c exit && \
    # grep -F .zshrc: zsh_profile.* | awk -f .zsh.awk | sort -nr | head

    if [[ "$PROFILE_STARTUP" == true ]]; then
      zmodload zsh/datetime
      setopt PROMPT_SUBST
      PS4='+$EPOCHREALTIME %N:%i> '
      logfile=$(mktemp zsh_profile.XXXXXXXX)
      echo "Logging to $logfile"
      exec 3>&2 2>$logfile
      setopt XTRACE
    fi
  '';
  zshConfigAfter = lib.mkAfter ''
    export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
    for file in "$HOME/.config/zsh/source"/**/*.zsh(N); do
      source "$file"
    done

    bindkey '^A' beginning-of-line
    bindkey -r '^S'
    stty -ixon
    bindkey '^S' end-of-line
    bindkey -r '^E'
    function zle_eval {
        echo -en "\e[2K\r"
        eval "$@"
        zle redisplay
    }
    function zle_refresh_p10k {
        zle_eval "source $HOME/.cache/wal/custom-fzf.sh; source $ZDOTDIR/.p10k.zsh; clear"
    }
    zle -N zle_refresh_p10k
    bindkey "^E" zle_refresh_p10k
    bindkey -r '^P'
    function zle_get_cwd {
        zle_eval "pwd | wl-copy"
    }
    zle -N zle_get_cwd
    bindkey "^P" zle_get_cwd

    ${lib.optionalString (config.zsh.pluginSettings.history-substring-search.enable) ''
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    ''}

    export PATH="$HOME/.local/bin:$PATH"
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    source $ZDOTDIR/.p10k.zsh
    source ${config.xdg.cacheHome}/wal/custom-fzf.sh

    ${lib.optionalString (config.zsh.pluginSettings.fzf.enable) ''
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'
      bindkey '^R' fzf-history-widget
    ''}

    ${lib.optionalString (config.zsh.debug.enable) ''
      if command -v uv >/dev/null; then
        autoload -Uz compinit && compinit
        compdef _uv uv
        _uv() { eval "$(uv generate-shell-completion zsh)" }
      fi
      if [[ "$PROFILE_STARTUP" == true ]]; then
        unsetopt XTRACE
        exec 2>&3 3>&-
      fi
    ''}

    eval "$(direnv hook zsh)"
  '';
in
{
  config = lib.mkMerge [
    (lib.mkIf (config.zsh.debug.enable) zshConfigBefore)
    zshConfigAfter
  ];
}
