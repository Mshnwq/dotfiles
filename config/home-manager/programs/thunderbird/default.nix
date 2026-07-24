# thunderbird.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  addons = pkgs.callPackage ./addons.nix {
    inherit lib pkgs;
  };
in
{
  # home.packages = [
  #   pkgs.thunderbird-mcp
  # ];
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    # Preferences applied to ALL profiles below.
    # settings = {
    #   "general.useragent.override" = "";
    #   "privacy.donottrackheader.enabled" = true;
    #   "mail.spellcheck.inline" = true;
    # };
    profiles = {
      # "default" profile — the one Thunderbird opens on startup.
      default = {
        isDefault = true;
        # settings = {
        #   "mail.spellcheck.inline" = true;
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
      dummy = {
        # isDefault = false;
        # settings = {
        #   "mail.spellcheck.inline" = false;
        # };
        # extraConfig = ''
        #   // Extra raw prefs for this profile go here.
        # '';
      };
      ict = {
        # isDefault = false;
        settings = {
          "mail.spellcheck.inline" = true;
          "extensions.autoDisableScopes" = 0;
        };
        # extraConfig = ''
        #   // Extra raw prefs for this profile go here.
        # '';
        extensions = [ addons.thunderbirdMcpXpi ];
      };
    };
  };
}
# programs.thunderbird.profiles.<name>.extensions
#
# List of ‹name› add-on packages to install for this profile.
#
# Note that it is necessary to manually enable extensions inside ‹name› after the first installation.
#
# To automatically enable extensions add "extensions.autoDisableScopes" = 0; to programs.thunderbird.profiles.<profile>.settings
