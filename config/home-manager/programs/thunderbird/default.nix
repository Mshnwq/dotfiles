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
    };
    profiles = {
      # "default" profile — the one Thunderbird opens on startup.
      default = {
        # isDefault = true;
        # settings = {
        #   "mailnews.start_page.enabled" = false;
        # };
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
