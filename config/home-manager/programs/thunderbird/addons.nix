{
  lib,
  pkgs,
}:
{
  thunderbirdMcpXpi = pkgs.stdenvNoCC.mkDerivation {
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
}
# Note that it is necessary to manually enable extensions inside ‹name› after the first installation.
# To automatically enable extensions add "extensions.autoDisableScopes" = 0; to programs.thunderbird.profiles.<profile>.settings

# TODO: https://services.addons.thunderbird.net/en-us/thunderbird/addon/pywalfox/
