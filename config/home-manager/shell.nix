{ config, pkgs, lib, ... }: {
  home.packages = [
    # pkgs.zsh  󱄅 
    pkgs.zsh-powerlevel10k
    pkgs.oh-my-zsh
    # pkgs.asdf-vm
  ];

  home.sessionVariables = {
    FZF_PATH = "${config.xdg.configHome}/fzf";
    # ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
  };
  home.file = {
    "${config.xdg.configHome}/fzf/shell".source = 
      pkgs.runCommand "fzf-shell" { } ''
        cp -r ${builtins.fetchGit {
          url = "https://github.com/junegunn/fzf.git";
          rev = "978b6254c71a8b71d0ad0e58bee74c70a53c1345";
        }}/shell $out
      '';
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.save = 20000;
    history.size = 20000;
    setOptions = [
      "HIST_FIND_NO_DUPS"   # When searching history don't display results already cycled through twice
      "AUTOCD"              # change directory just by typing its name
      "PROMPT_SUBST"        # enable command substitution in prompt
      "MENU_COMPLETE"       # Automatically highlight first element of completion menu
      "LIST_PACKED"	        # The completion menu takes less space.
      "AUTO_LIST"           # Automatically list choices on ambiguous completion.
      "COMPLETE_IN_WORD"    # Complete from both ends of a word.
    ];
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    initContent = lib.mkAfter ''
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

      # export PATH=$HOME/.local/share/nvim/mason/bin"
      export PATH="$HOME/.local/bin:$PATH"

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $ZDOTDIR/.p10k.zsh
    '';
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
      enable = true;
      plugins = [ 
        "git"
        # "asdf"
      ];
    };
  };
}
