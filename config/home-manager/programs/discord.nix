# programs/discord.nix
let
  bdAddonsDrv =
    { pkgs, ... }:
    pkgs.fetchFromGitHub {
      owner = "mwittrien";
      repo = "BetterDiscordAddons";
      rev = "e3f2e5b27efca0e4893ebb7779b9c28a86d07651";
      hash = "sha256-TJjTUpk4BnPbghYjqEj/goTryqWqi8O82TSoDUlPiTc=";
    };

  mkDiscordVariant =
    {
      pkgs,
      config,
      inputs,
      iconName,
      binaryName,
      basePackage,
      desktopFileName,
      packageOverrides ? { },
    }:
    let
      package = (basePackage.override packageOverrides).overrideAttrs ({
        postFixup = ''
          wrapProgram $out/opt/${binaryName}/${binaryName} \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations"
        '';
      });
    in
    {
      home.packages = [
        package
        pkgs.betterdiscordctl
      ];

      # Create desktop entry with nixGL wrapper
      xdg.desktopEntries.${desktopFileName} = {
        name = binaryName;
        exec = "nixGLIntel ${binaryName} %u";
        icon = "${iconName}";
        type = "Application";
        categories = [
          "InstantMessaging"
          "Network"
        ];
        settings = {
          StartupWMClass = binaryName;
        };
      };
    };
in
{
  stable =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    mkDiscordVariant {
      inherit pkgs config inputs;
      iconName = "discord";
      binaryName = "Discord";
      basePackage = pkgs.discord;
      desktopFileName = "discord";
      packageOverrides = {
        withOpenASAR = true;
      };
    };

  canary =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    mkDiscordVariant {
      inherit pkgs config inputs;
      iconName = "discord-canary";
      binaryName = "DiscordCanary";
      basePackage = pkgs.discord-canary;
      desktopFileName = "discord-canary";
      packageOverrides = {
        withOpenASAR = true;
        nss = pkgs.nss_latest;
      };
    };
}

# NOTE: do this after for theme
# betterdiscordctl -i traditional -f 'canary' install
# ln -sf "$XDG_CACHE_HOME/wal/custom-discord.theme.css" "$XDG_CONFIG_HOME/BetterDiscord/themes/custom-discord.theme.css"
