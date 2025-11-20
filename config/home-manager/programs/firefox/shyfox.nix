profile:
{
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.programs.firefox;
in
{
  home.file."${cfg.profilesPath}/${profile}/chrome".source = pkgs.shyfox;
  programs.firefox.profiles.${profile} = {
    userChrome = "";
    userContent = "";
    settings = {
      # Theme
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.download.autohideButton" = false;
      "browser.tabs.groups.smart.enabled" = false;
      ### ShyFox ###
      "sidebar.revamp" = false;
      "layout.css.has-selector.enabled" = true;
      "browser.urlbar.suggest.calculator" = false;
      "browser.urlbar.unitConversion.enabled" = false;
      "browser.urlbar.trimHttps" = false;
      "browser.urlbar.trimURLs" = false;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
      "widget.gtk.ignore-bogus-leave-notify" = 1;
      "svg.context-properties.content.enabled" = true;
    };
  };
}
