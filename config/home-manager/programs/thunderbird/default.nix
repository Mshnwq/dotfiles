# thunderbird/default.nix
{
  lib,
  pkgs,
  # config,
  ...
}:
let
  addons = pkgs.callPackage ./addons.nix {
    inherit lib pkgs;
  };
in
# https://home-manager-options.extranix.com/?query=thunder&release=master
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
      "mail.spellcheck.inline" = true;
      "extensions.autoDisableScopes" = 0;
      "mailnews.start_page.enabled" = false;
    };
    nativeMessagingHosts = [ pkgs.pywalfox-native ];
    profiles = {
      # "default" profile — the one Thunderbird opens on startup.
      default = {
        extensions = [
          addons.mcp
          addons.cli
          addons.pywalfox
        ];
        # isDefault = true;
        # extraConfig = ''
        #   // Extra raw prefs for this profile go here.
        # '';
        # search = {
        #   default = "ddg";
        #   force = true;
        # };
      };
      ict = {
        isDefault = true;
        extensions = [
          addons.mcp
          addons.cli
          addons.pywalfox
        ];
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
