# programs/rust.nix
{
  config,
  pkgs,
  ...
}:
let
  glim = pkgs.rustPlatform.buildRustPackage {
    pname = "glim";
    # version = "git-cd53dae";
    # src = pkgs.fetchFromGitHub {
    #   owner = "junkdog";
    #   repo = "glim";
    #   rev = "cd53dae";
    #   hash = "sha256-yAymON+o2slcyCpEq5prkffUelW5jV3I9JSJuQc6+jc=";
    # };
    # cargoHash = "sha256-9DxUgv10cSsTlwqTJWtNxcd/hbS6pGZ+XCPjL1wbCh8=";
    version = "git-f141972";
    src = pkgs.fetchFromGitHub {
      owner = "mshnwq";
      repo = "glim";
      rev = "f1419721699e400f9ca035cfd5b4fb72c58c6410";
      hash = "sha256-vNJn2Xf8KBZMDD3hK0SXLQ9+84hDid2+NHNviU3oCGs=";
    };
    cargoHash = "sha256-9DxUgv10cSsTlwqTJWtNxcd/hbS6pGZ+XCPjL1wbCh8=";

    nativeBuildInputs = [ pkgs.pkg-config ]; # for build-time discovery
    buildInputs = [ pkgs.openssl ]; # OpenSSL headers & libs
  };
in
{
  home.packages =
    with pkgs;
    [
      cargo
      rustc
      eza
      bat
      dfrs
      ripgrep
      tldr
      gpg-tui
      serie
      termscp
    ]
    ++ ([
      (pkgs.symlinkJoin {
        name = "glim";
        buildInputs = [ pkgs.makeWrapper ];
        paths = [ glim ];
        postBuild =
          let
            configFile = pkgs.writeText "glim.toml" ''
              gitlab_url = "https://gitlab.com/api/v4"
              gitlab_token = ""
              gitlab_token_file = "${config.sops.secrets."glim-token".path}"
              animations = true
            '';
          in
          ''
            wrapProgram $out/bin/glim \
              --append-flags "--config ${configFile}"
          '';
      })
    ]);
}
