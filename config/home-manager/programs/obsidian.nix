{
  pkgs,
  ...
}:
let
  advancedUri = pkgs.buildNpmPackage {
    pname = "obsidian-advanced-uri";
    version = "git-1ab216b";
    src = pkgs.fetchFromGitHub {
      owner = "Mshnwq";
      repo = "obsidian-advanced-uri";
      rev = "1ab216b";
      hash = "sha256-Ag1XU2OEx3kM0w63g8d/a2bpJMGKPSlzQRbDjDFEjh4=";
    };
    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.typescript
    ];
    npmDepsHash = "sha256-fnw6Etc5TEXEwUfrj7IClAf4ID2MPAXpnqVLuFt4mjU";
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
  pywalPlugin = pkgs.stdenv.mkDerivation {
    pname = "obsidian-pywal-theme";
    version = "git-1001939";
    src = pkgs.fetchFromGitHub {
      owner = "Schweem";
      repo = "Pywal-Obsidian";
      rev = "1001939";
      hash = "sha256-CnGhNBtRKBG6bmemXaG9x41qM9/0s1/eTdLRyJpcsk4=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r pywal-theme/* $out/
    '';
  };
in
{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = [
        pywalPlugin
        advancedUri
      ];
    };
    vaults = {
      "Home" = {
        enable = true;
        target = "Documents/Obsidian/Home";
      };
      "Dummy" = {
        enable = true;
        target = "Documents/Obsidian/Dummy";
      };
    };
  };
  xdg.desktopEntries.obsidian-nix = {
    name = "Obsidian (nix)";
    exec = "Obsidian %u";
    icon = "obsidian";
    categories = [ "Utility" ];
    type = "Application";
    startupNotify = true;
  };
  # Custom wrapper for Obsidian
  home.file.".local/bin/Obsidian".text = ''
    #!/usr/bin/env bash
    exec nixGLIntel obsidian "$@" --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations
  '';
  home.file.".local/bin/Obsidian".executable = true;
}
