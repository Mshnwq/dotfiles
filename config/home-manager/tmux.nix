{ config, pkgs, lib, ... }: {
  home.packages = [
    pkgs.tmux
    pkgs.tmuxp
  ];
  home.file = {
    "${config.xdg.configHome}/tmux/plugins/tpm".source =
      pkgs.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tpm";
        rev = "v3.1.0";
        hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
      };
    "${config.xdg.configHome}/tmux/plugins/tmux-dracula".source =
      pkgs.fetchFromGitHub {
        owner = "mshnwq";
        repo = "tmux-dracula";
  	rev = "ae4e0a0de7a1f4a993039a96a6ec77a5c1f4b36a";
  	hash = "sha256-KpQTjPfUd42Q5ZaQdN7k5C+b1Mz5sJ29m6u5spywt34=";
      };
    "${config.xdg.configHome}/tmux/plugins/tmux-floax".source =
      pkgs.fetchFromGitHub {
        owner = "mshnwq";
        repo = "tmux-floax";
        rev = "1b23c5758ac8ba439fe3e70bb65a65247c32a3eb";
        hash = "sha256-s1jUx6HFgtVwTjdiAtMLw42//yfLsCEjqgdyQNF+P7c=";
      };
    # ".local/bin/tmux".source = "${pkgs.tmux}/bin/tmux";
    # tmux binary order nix > user > system 
  };
  home.sessionVariables = {
    TMUXP_CONFIGDIR = "${config.xdg.configHome}/tmux/tmuxp";
  };
}
