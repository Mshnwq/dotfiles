# programs/zsh/plugins.nix
{
  pkgs,
  ...
}:
{
  plugins = {
    history-substring-search = {
      name = pkgs.zsh-history-substring-search.pname;
      src = pkgs.zsh-history-substring-search.src;
    };
    syntax-highlighting = {
      name = pkgs.zsh-syntax-highlighting.pname;
      src = pkgs.zsh-syntax-highlighting.src;
    };
    autosuggestions = {
      name = pkgs.zsh-autosuggestions.pname;
      src = pkgs.zsh-autosuggestions.src;
    };
    nix-shell = {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    };
    fzf-tab = {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab.src;
      file = "fzf-tab.zsh"; # because different name on pkgs
    };
    fzf = {
      name = "fzf-zsh-plugin";
      src = pkgs.fetchFromGitHub {
        owner = "unixorn";
        repo = "fzf-zsh-plugin";
        rev = "04ae801499a7844c87ff1d7b97cdf57530856c65";
        hash = "sha256-FEGhx36Z5pqHEOgPsidiHDN5SXviqMsf6t6hUZo+I8A=";
      };
    };
  };
}
