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
    pkgs.dfrs
    pkgs.ripgrep
    pkgs.tldr
    pkgs.serie
    pkgs.termscp
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "glim";
      version = "git-cd53dae";
      src = pkgs.fetchFromGitHub {
        owner = "junkdog";
        repo = "glim";
        rev = "cd53dae";
        hash = "sha256-yAymON+o2slcyCpEq5prkffUelW5jV3I9JSJuQc6+jc=";
      };
      cargoHash = "sha256-9DxUgv10cSsTlwqTJWtNxcd/hbS6pGZ+XCPjL1wbCh8=";
      # 👇 This fixes the OpenSSL + pkg-config issue
      nativeBuildInputs = [ pkgs.pkg-config ]; # for build-time discovery
      buildInputs = [ pkgs.openssl ]; # OpenSSL headers & libs
    })
  ];
}
