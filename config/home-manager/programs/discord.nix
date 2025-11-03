let
  bdAddonsDrv =
    { pkgs, fetchFromGitHub }:
    fetchFromGitHub {
      owner = "mwittrien";
      repo = "BetterDiscordAddons";
      rev = "e3f2e5b27efca0e4893ebb7779b9c28a86d07651";
      hash = "sha256-TJjTUpk4BnPbghYjqEj/goTryqWqi8O82TSoDUlPiTc=";
    };
in
{

  stable =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    let
      binaryName = "Discord";
      package =
        (pkgs.discord.override {
          # <https://github.com/GooseMod/OpenAsar>
          withOpenASAR = true;
        }).overrideAttrs
          ({
            # why is this missing?
            # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/instant-messengers/discord/linux.nix#L99>
            postFixup = ''
              wrapProgram $out/opt/${binaryName}/${binaryName} \
                --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations" \
            '';
          });
    in
    {
      home.packages = [
        package
        pkgs.betterdiscordctl
      ];
      home.activation.wrapDiscordNixGL =
        inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''
            mkdir -p "${config.xdg.dataHome}/applications"
            discord_desktop="${config.xdg.dataHome}/applications/discord.desktop"
            if [ ! -f "$discord_desktop" ]; then
              cp ${package}/share/applications/discord.desktop "$discord_desktop"
              sed -i 's|^Exec=.*|Exec=nixGLIntel ${binaryName}|' "$discord_desktop"
            fi
          '';
    };

  canary =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    let
      binaryName = "DiscordCanary";
      package =
        (pkgs.discord-canary.override {
          # <https://github.com/GooseMod/OpenAsar>
          withOpenASAR = true;
          # fix for not respecting system browser
          nss = pkgs.nss_latest;
        }).overrideAttrs
          ({
            # why is this missing?
            # <https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/instant-messengers/discord/linux.nix#L99>
            postFixup = ''
              wrapProgram $out/opt/${binaryName}/${binaryName} \
                --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations" \
            '';
          });
      bdAddons = pkgs.callPackage bdAddonsDrv { };
    in
    {
      home.packages = [
        package
        pkgs.betterdiscordctl
      ];
      home.activation.wrapDiscordCanaryNixGL =
        inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''
            mkdir -p "${config.xdg.dataHome}/applications"
            discord_desktop="${config.xdg.dataHome}/applications/discord-canary.desktop"
            if [ ! -f "$discord_desktop" ]; then
              cp ${package}/share/applications/discord-canary.desktop "$discord_desktop"
              sed -i 's|^Exec=.*|Exec=nixGLIntel ${binaryName}|' "$discord_desktop"
            fi
          '';
      # NOTE: do this after for theme
      # betterdiscordctl -i traditional -f 'canary' install
      # ln -sf "$XDG_CACHE_HOME/wal/custom-discord.theme.css" "$XDG_CONFIG_HOME/BetterDiscord/themes/custom-discord.theme.css"
    };
}
