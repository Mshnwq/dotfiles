# programs/email/thunderbird.nix
{
  lib,
  pkgs,
  config,
  # inputs',
  ...
}:
let
  addons = pkgs.callPackage ./addons.nix {
    inherit lib pkgs;
  };
in
{
  sops.secrets = {
    outlook-address = {
      mode = "0400";
    };
    outlook-real = {
      mode = "0400";
    };
  };
  accounts.email.accounts.outlook = {
    realName = builtins.readFile config.sops.secrets."outlook-real".path;
    address = builtins.readFile config.sops.secrets."outlook-address".path;
    flavor = "outlook.office365.com";
    primary = true; # only ONE account across accounts.email may set this
    thunderbird = {
      enable = true;
      profiles = [ "ict" ];
    };
  };

  programs.thunderbird = {
    enable = true;
    # v146 above has ~/thunderbird bug https://bugzilla.mozilla.org/show_bug.cgi?id=2007074
    # package = pkgs.thunderbird; # is v152, outlook smtp broke here we need v153
    # package = pkgs.thunderbird-140; # does not login to outlook
    # i need the thunderbird from here https://github.com/r-ryantm/nixpkgs/tree/auto-update/thunderbird-latest-bin-unwrapped it is 153, show me how to add is as input
    # package =
    #   inputs'.nixpkgs-tb.legacyPackages.${pkgs.stdenv.hostPlatform.system}.thunderbird;
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
      "mail.spellcheck.inline" = true;
      "extensions.autoDisableScopes" = 0; # auto adds extensions
      "mailnews.start_page.enabled" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
    };
    nativeMessagingHosts = [ pkgs.pywalfox-native ];
    profiles = {
      # "default" profile — the one Thunderbird opens on startup.
      default = {
        extensions = with addons; [
          wal
        ];
        # https://github.com/catppuccin/thunderbird
        # https://home-manager.dev/manual/unstable/options/home-manager/programs/thunderbird.html?highlight=thunder#opt-programs.thunderbird.profiles._name_.userChrome
        userChrome = ''
          /* Hide tab bar in Thunderbird */
          #tabs-toolbar {
            visibility: collapse !important;
          }
        '';
        # https://home-manager.dev/manual/unstable/options/home-manager/programs/thunderbird.html?highlight=thunder#opt-programs.thunderbird.profiles._name_.userContent
        userContent = ''
          *{scrollbar-width:none !important}
        '';
        # https://github.com/catppuccin/thunderbird
      };
      ict = {
        isDefault = true;
        extensions = with addons; [
          mcp
          cli
          wal
        ];
        # extraConfig = ''
        #   // Extra raw prefs for this profile go here.
        # '';
        # search = {
        #   default = "ddg";
        #   force = true;
        # };
      };
    };
  };
  programs.which-key = {
    entries = [
      {
        key = "e";
        desc = "Email";
        cmd = "thunderbird";
      }
    ];
  };
}
