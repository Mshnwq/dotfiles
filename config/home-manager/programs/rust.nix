# programs/rust.nix
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  glim = pkgs.rustPlatform.buildRustPackage {
    pname = "glim";
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
            glim-token =
              if inputs.useSops then config.sops.secrets."glim-token".path else "xxx";
            configFile = pkgs.writeText "glim.toml" ''
              gitlab_url = "https://gitlab.com/api/v4"
              gitlab_token = ""
              gitlab_token_file = "${glim-token}"
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
