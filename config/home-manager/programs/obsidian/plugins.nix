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
  # https://excalidraw-obsidian.online/
  excalidraw =
    let
      version = "2.22.0";
      # https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/tag/2.22.0
      mainJs = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/main.js";
        hash = "sha256:8f7d5dc538228020805a255db9615ba2fdb82a9c0e6081f1b37ee7c2750ab37e";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/manifest.json";
        hash = "sha256:e4788bd00c9890f62c939d51676ed2eaa392748a738f292d47721df6fe100553";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/styles.css";
        hash = "sha256:5581af67d9a8cc133774420c7974d03a7cbcb5ebce209d6e8e0a53e00bde3f00";
      };
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "obsidian-excalidraw-plugin";
      version = "v${version}";
      dontUnpack = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp ${mainJs} $out/main.js
        cp ${manifestJson} $out/manifest.json
        cp ${stylesCss} $out/styles.css
        runHook postInstall
      '';
    };
}
