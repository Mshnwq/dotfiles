# programs/obsidian/plugins.nix
{
  pkgs,
  ...
}:
{
  advancedUri =
    let
      version = "1.46.1";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/main.js";
        hash = "sha256:d10300fb667eb9e93417427fc3ea010f46db020885d29c5decc78735c14ab162";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/manifest.json";
        hash = "sha256:fa12d5488bf1d61b829272b15de72fea27d1f2d6ac854f97ec97a6cc2784c2f1";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-advanced-uri";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      settings = {
        "openFileOnWrite" = true;
        "openDailyInNewPane" = false;
        "openFileOnWriteInNewPane" = false;
        "openFileWithoutWriteInNewPane" = true;
        "idField" = "id";
        "useUID" = false;
        "addFilepathWhenUsingUID" = false;
        "allowEval" = false;
        "includeVaultName" = true;
        "vaultParam" = "name";
        "linkFormats" = [
          {
            "name" = "Markdown";
            "format" = "[{{name}}]({{uri}})";
          }
        ];
      };
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
