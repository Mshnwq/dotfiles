{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ zsh-powerlevel10k zoxide util-linux ];

  home.sessionVariables = { FZF_PATH = "${config.xdg.configHome}/fzf"; };
  home.file = {
    "${config.xdg.configHome}/fzf/shell".source =
      pkgs.runCommand "fzf-shell" { } ''
        cp -r ${
          builtins.fetchGit {
            url = "https://github.com/junegunn/fzf.git";
            rev = "978b6254c71a8b71d0ad0e58bee74c70a53c1345";
          }
        }/shell $out
      '';
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.save = 20000;
    history.size = 20000;
    setOptions = [
      "HIST_FIND_NO_DUPS" # When searching history don't display results already cycled through twice
      "AUTOCD" # change directory just by typing its name
      "PROMPT_SUBST" # enable command substitution in prompt
      "MENU_COMPLETE" # Automatically highlight first element of completion menu
      "LIST_PACKED" # The completion menu takes less space.
      "AUTO_LIST" # Automatically list choices on ambiguous completion.
      "COMPLETE_IN_WORD" # Complete from both ends of a word.
    ];
    completionInit = ''
      # Optimized compinit with cache and bytecode
      autoload -Uz compinit
      if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
        compinit -C        # use cache if < 24h old
      else
        compinit -u        # skip security checks
        zcompile -R $ZDOTDIR/.zcompdump
      fi
    '';
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    initContent = let
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
            zle_eval "source $ZDOTDIR/.p10k.zsh; clear"
        }
        zle -N zle_refresh_p10k
        bindkey "^E" zle_refresh_p10k
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^R' fzf-history-widget

        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source $ZDOTDIR/.p10k.zsh
        # only show error
        export DIRENV_LOG_FORMAT=
        eval "$(direnv hook zsh)"

        if command -v uv >/dev/null; then
          autoload -Uz compinit && compinit
          compdef _uv uv
          _uv() { eval "$(uv generate-shell-completion zsh)" }
        fi

        # FOR DEBUG
        if [[ "$PROFILE_STARTUP" == true ]]; then
          unsetopt XTRACE
          exec 2>&3 3>&-
        fi
      '';
    in lib.mkMerge [ zshConfigBefore zshConfigAfter ];

    # TODO:
    # remove plugins from here manually manage and choose to fpath source
    # use atuin
    # https://github.com/atuinsh/atuin
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab.src;
        file = "fzf-tab.zsh"; # because different name on pkgs
      }
      {
        name = "fzf-zsh-plugin";
        src = pkgs.fetchFromGitHub {
          owner = "unixorn";
          repo = "fzf-zsh-plugin";
          rev = "04ae801499a7844c87ff1d7b97cdf57530856c65";
          hash = "sha256-FEGhx36Z5pqHEOgPsidiHDN5SXviqMsf6t6hUZo+I8A=";
        };
      }
      {
        name = pkgs.zsh-autosuggestions.pname;
        src = pkgs.zsh-autosuggestions.src;
      }
      {
        name = pkgs.zsh-syntax-highlighting.pname;
        src = pkgs.zsh-syntax-highlighting.src;
      }
      {
        name = pkgs.zsh-history-substring-search.pname;
        src = pkgs.zsh-history-substring-search.src;
      }
    ];
    oh-my-zsh = {
      enable = false;
      plugins = [ 
        "git"
      ];
    };
  };
}
