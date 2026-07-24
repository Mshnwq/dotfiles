# thunderbird/addons.nix
{
  lib,
  pkgs,
}:
# Note that it is necessary to manually enable extensions inside ‹name› after the first installation.
# To automatically enable extensions add "extensions.autoDisableScopes" = 0; to programs.thunderbird.profiles.<profile>.settings
# TODO: https://services.addons.thunderbird.net/en-us/thunderbird/addon/pywalfox/
{
  mcp = pkgs.stdenvNoCC.mkDerivation {
    pname = "thunderbird-mcp-xpi";
    version = "0.7.4";
    src = pkgs.fetchFromGitHub {
      owner = "TKasperczyk";
      repo = "thunderbird-mcp";
      rev = "e6e9014b2baefea68ab97db76586cf875aca77ba"; # v0.7.4
      hash = "sha256-jrmHqToe+lJTpoG1QYaYHVk84PaO5zKAXLwr3Opl0A4=";
    };
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -m644 "$src/dist/thunderbird-mcp.xpi" "$dst/thunderbird-mcp@tkasperczyk.dev.xpi"
      runHook postInstall
    '';
    meta = with lib; {
      description = "Thunderbird MCP add-on (pinned to a GitHub commit)";
      homepage = "https://github.com/TKasperczyk/thunderbird-mcp";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  cli = pkgs.stdenvNoCC.mkDerivation {
    pname = "thunderbird-cli-xpi";
    version = "2.0.0"; # extension manifest version (repo tag is v1.0.2)
    src = pkgs.fetchFromGitHub {
      owner = "vitalio-sh";
      repo = "thunderbird-cli";
      rev = "670e995e09a1c09b4dd1fdb3f1cce04ad7e8c3d1"; # v1.0.2
      hash = "sha256-jtIXOHjijFkwdh5FWrqdSfEwbEmWQud8Qr2jsTEwJts=";
    };
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -m644 "$src/dist/releases/thunderbird_ai_bridge-2.0.0-tb.xpi" "$dst/thunderbird-ai@extension.xpi"
      runHook postInstall
    '';
    meta = with lib; {
      description = "Thunderbird AI Bridge add-on for thunderbird-cli (pinned to a GitHub commit)";
      homepage = "https://github.com/vitalio-sh/thunderbird-cli";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
