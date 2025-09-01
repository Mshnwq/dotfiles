{ pkgs, ... }:
let
  profile = "mshnwq.default";
  profileName = "mshnwq";

  extensions = {
    rycee = pkgs.nur.repos.rycee.firefox-addons;
    mshnwq = pkgs.firefox-extensions;
  };
in {

  # only need pywalfax --install and sidebery load addons and untrap
  programs.firefox.enable = true;

  imports = [
    (import ./blocking.nix profile)
  ];

  home.packages = [ pkgs.firefoxpwa ];
  programs.firefox.nativeMessagingHosts = [ pkgs.firefoxpwa ];

  programs.firefox.profiles.${profile} = {
    id = 0;
    isDefault = true;
    name = profileName;

    # real bullshit
    userChrome = ''
      @import url("ShyFox/shy-variables.css");
      @import url("ShyFox/shy-global.css");
      @import url("ShyFox/shy-sidebar.css");
      @import url("ShyFox/shy-toolbar.css");
      @import url("ShyFox/shy-navbar.css");
      @import url("ShyFox/shy-findbar.css");
      @import url("ShyFox/shy-controls.css");
      @import url("ShyFox/shy-compact.css");
      @import url("ShyFox/shy-icons.css");
      @import url("ShyFox/shy-floating-search.css");
    '';
    userContent = ''
      @import url("ShyFox/content/shy-new-tab.css");
      @import url("ShyFox/content/shy-sidebery.css");
      @import url("ShyFox/content/shy-about.css");
      @import url("ShyFox/content/shy-global-content.css");
      @import url("ShyFox/shy-variables.css");
    '';

    settings = {
      # Do not require manual intervention to enable extensions.
      # This might be a security hole.
      "extensions.autoDisableScopes" = 0;

      # Hardware
      "gfx.webrender.all" = true;
      ### from Bazzite Repo ###
      "media.ffmpeg.vaapi.enabled" = true;
      # not hw but bazzite still
      "media.webspeech.synth.enabled" = false;
      "reader.parse-on-load.enabled" = false;
      # remove machine learning
      "extensions.ml.enabled" = false;
      "browser.ml.chat.enabled" = false;

      # Theme 
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.download.autohideButton" = false;
      "browser.tabs.groups.smart.enabled" = false;
      ### ShyFox ###
      "sidebar.revamp" = false;
      "layout.css.has-selector.enabled" = true;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.trimURLs" = true;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
      "widget.gtk.ignore-bogus-leave-notify" = 1;
      "svg.context-properties.content.enabled" = true;
    };

    extensions.packages = with extensions; [
      rycee.sidebery
      rycee.userchrome-toggle-extended
      rycee.darkreader
      rycee.clearurls
      rycee.sponsorblock
      rycee.return-youtube-dislikes
      rycee.videospeed
      rycee.search-by-image
      rycee.pwas-for-firefox  # idk
      rycee.pywalfox

      # unfree extensions - manually allowed
      (rycee.untrap-for-youtube.override { meta.license.free = true; })
      (rycee.video-downloadhelper.override { meta.license.free = true; })
      (rycee.tampermonkey.override { meta.license.free = true; })

      mshnwq.duplicate-tab-shortcut
      # TODO:
      # rycee.web-clipper-obsidian
      # rycee.keepassxc-browser
      # only missing enhancer-for-youtube
    ];
  };
}
