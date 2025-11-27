# programs/zsh/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.zsh;
  pluginDefs = import ./plugins.nix { inherit pkgs; };
  availablePlugins = pluginDefs.plugins;
  enabledPlugins = lib.attrValues (
    lib.filterAttrs (
      name: plugin: cfg.pluginSettings.${name}.enable or false
    ) availablePlugins
  );
in
{
  options.zsh.pluginSettings = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to enable this zsh plugin";
          };
        };
      }
    );
    default = { };
    description = "Settings for individual zsh plugins";
  };
  options.zsh.enableDebug = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    home.packages = with pkgs; [
      bat
      dfrs
      eza
      tldr
      ripgrep
      util-linux
      zoxide
      zsh-powerlevel10k
    ];
    home.sessionVariables = {
      FZF_PATH = "${config.xdg.configHome}/fzf";
    };
    home.file = {
      "${config.xdg.configHome}/fzf/shell".source = pkgs.runCommand "fzf-shell" { } ''
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
      initContent = (import ./config.nix { inherit config pkgs lib; }).config;
      plugins = enabledPlugins;
    };
  };
}
