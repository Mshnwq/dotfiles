{ pkgs, lib, ... }: {
  home.packages = [
    pkgs.cargo
    pkgs.rustc
    # OVERKILL TOO SLOW 
    # (pkgs.rustPlatform.buildRustPackage rec {
    #   pname = "eza";
    #   version = "git-97f9f36";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "eza-community";
    #     repo = "eza";
    #     rev = "97f9f36";
    #     hash = "sha256-lktsG+QwPZGj56DJcRn3/z6Uay9vY3qGF3cDWSxiVg8=";
    #   };
    #   cargoHash = "sha256-19PPPrHJ/Vbavr7wQPyMp+/f8fLHrzZwG7roV7rjZc0=";
    # })
    pkgs.eza
    pkgs.bat
    pkgs.duf # GO lang ! 
    pkgs.dfrs # has colors
    pkgs.dysk # better info
    pkgs.tldr
    pkgs.serie
    # pkgs.termscp 
    # pkgs.catppuccin-whiskers  # no need cursors has a *.nix
  ];
}
