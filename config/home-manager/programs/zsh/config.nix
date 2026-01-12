# programs/zsh/config.nix
{
  config,
  pkgs,
  lib,
  ...
}:
# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
let
  zshConfigDebug = lib.mkBefore ''
    # https://kev.inburke.com/kevin/profiling-zsh-startup-time/
    # https://esham.io/2018/02/zsh-profiling
    if [[ $ZPROF == true ]]; then
      zmodload zsh/zprof
    fi
    if [[ $ZDEBUG == true ]]; then
      zmodload zsh/datetime
      setopt PROMPT_SUBST
      PS4='+$EPOCHREALTIME %N:%i> '
      exec 3>&2 2>$ZDOTDIR/zdebug
      setopt XTRACE
    fi
  '';
  # https://github.com/romkatv/zsh-bench?tab=readme-ov-file#instant-prompt
  zshConfigBefore = lib.mkOrder 550 ''
    if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
  '';
  zshConfigAfter = lib.mkAfter ''
    export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
    export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v linuxbrew | paste -sd:)

    for file in "$HOME/.config/zsh/source"/**/*.zsh(N); do
      source "$file"
    done

    if [[ -f "${config.xdg.cacheHome}/p10k/powerlevel10k.zsh-theme" ]]; then
      source "${config.xdg.cacheHome}/p10k/powerlevel10k.zsh-theme"
    else
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    fi
    source $ZDOTDIR/.p10k.zsh
    [[ -f "${config.xdg.cacheHome}/wal/custom-fzf.sh" ]] && source ${config.xdg.cacheHome}/wal/custom-fzf.sh

    # Keybindings
    bindkey '^A' beginning-of-line
    bindkey -r '^E'
    bindkey -r '^S'
    bindkey '^S' end-of-line

    # ZLE functions
    function zle_eval { echo -en "\e[2K\r"; eval "$@"; zle redisplay }
    function zle_refresh_p10k { zle_eval "source $HOME/.cache/wal/custom-fzf.sh; source $ZDOTDIR/.p10k.zsh; clear" }
    function zle_get_cwd { zle_eval "pwd | wl-copy" }
    function zle_wl_copy { echo -n "$BUFFER" | wl-copy; }
    function zle_append_wl_copy { BUFFER="$BUFFER | wl-copy"; zle end-of-line }
    function zle_append_stdout { BUFFER="$BUFFER 2>&1"; zle end-of-line }

    zle -N zle_refresh_p10k; bindkey "^E" zle_refresh_p10k
    zle -N zle_get_cwd; bindkey "^P" zle_get_cwd
    zle -N zle_wl_copy; bindkey "^Y" zle_wl_copy
    zle -N zle_append_wl_copy; bindkey '^\' zle_append_wl_copy
    zle -N zle_append_stdout; bindkey '^]' zle_append_stdout
    autoload -Uz edit-command-line
    zle -N edit-command-line; bindkey '^_' edit-command-line

    # Plugins & Optionals
    ${lib.optionalString (config.zsh.pluginSettings.history-substring-search.enable) ''
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    ''}
    ${lib.optionalString (config.zsh.pluginSettings.fzf.enable) ''
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'
      bindkey '^R' fzf-history-widget
    ''}
    ${lib.optionalString (config.zsh.direnv.enable) ''
      # UV completions (lazy load)
      # if command -v uv &>/dev/null; then
      #   # autoload -Uz compinit && compinit
      #   _uv() { eval "$(uv generate-shell-completion zsh)" }
      #   compdef _uv uv
      # fi
      # Direnv hook
      eval "$(direnv hook zsh)"
    ''}
    ${lib.optionalString (config.zsh.debug.enable) ''
      _zprof() {
        cd $ZDOTDIR && rm ./zprof
        ZPROF=true /bin/zsh -i --login -c exit && cat zprof | less
      }
      if [[ $ZPROF == true ]]; then
        zprof > $ZDOTDIR/zprof
      fi
      _zdebug() {
        cd $ZDOTDIR && rm ./zdebug
        ZDEBUG=true /bin/zsh -i --login -c exit && \
        grep -F .zshrc: zdebug | awk -f .zdebug.awk | sort -nr | less
      }
      if [[ $ZDEBUG == true ]]; then
        unsetopt XTRACE
        exec 2>&3 3>&-
      fi
    ''}
  '';
in
{
  config = lib.mkMerge [
    (lib.mkIf (config.zsh.debug.enable) zshConfigDebug)
    zshConfigBefore
    zshConfigAfter
  ];
}
