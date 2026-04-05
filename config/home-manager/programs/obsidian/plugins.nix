{
  pkgs,
  ...
}:
{
  advancedUri = pkgs.buildNpmPackage {
    pname = "obsidian-advanced-uri";
    version = "git-1ab216b";
    src = pkgs.fetchFromGitHub {
      owner = "Mshnwq";
      repo = "obsidian-advanced-uri";
      rev = "1ab216b";
      hash = "sha256-Ag1XU2OEx3kM0w63g8d/a2bpJMGKPSlzQRbDjDFEjh4=";
    };
    nativeBuildInputs = with pkgs; [
      nodejs_22
      typescript
    ];
    npmDepsHash = "sha256-fnw6Etc5TEXEwUfrj7IClAf4ID2MPAXpnqVLuFt4mjU=";
    npmDepsHook = ''
      export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
      export NPM_CONFIG_FETCH_TIMEOUT=1200000
      export NPM_CONFIG_FETCH_RETRIES=10
    '';
    npmBuildScript = "build";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp main.js manifest.json $out/
      runHook postInstall
    '';
  };
}
