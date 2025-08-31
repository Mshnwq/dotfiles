{ pkgs, ... }:
let
  profile = "mshnwq.default";
  profileName = "mshnwq";

  extensions = {
    rycee = pkgs.nur.repos.rycee.firefox-addons;
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

    userChrome = pkgs.shyfox;

    settings = {
      # Do not require manual intervention to enable extensions.
      # This might be a security hole.
      "extensions.autoDisableScopes" = 0;

      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      "gfx.webrender.all" = true;

      "browser.download.autohideButton" = false;

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

      # I think `panel_photon` and `panel_full` are mutually exclusive, not sure which to use.
      # In the hamburger menu, with both enabled, the zoom icon is offset to the left.
      # "userChrome.icon.panel_photon" = true;
      "userChrome.icon.panel_full" = true;
      "userChrome.icon.library" = true;
      "userChrome.icon.panel" = true;
      "userChrome.icon.menu" = true;
      "userChrome.icon.context_menu" = true;
      "userChrome.icon.global_menu" = true;
      "userChrome.icon.global_menubar" = true;
      #"userChrome.icon.1-25px_stroke" = true;
      "userChrome.icon.account_image_to_right" = true;
      "userChrome.icon.account_label_to_right" = true;
      "userChrome.icon.menu.full" = true;
      "userChrome.icon.global_menu.mac" = true;
    };

    extensions.packages = with extensions; [
      rycee.sidebery
      rycee.userchrome-toggle-extended
      rycee.untrap-for-youtube
      rycee.darkreader
      rycee.clearurls
      rycee.sponsorblock
      rycee.return-youtube-dislikes
      rycee.videospeed
      rycee.search-by-image
      rycee.tampermonkey
      rycee.pwas-for-firefox
      rycee.pywalfox

    # pkgs.nur.repos.rycee.firefox-addons.video-downloadhelper  # unfree
    # pkgs.nur.repos.rycee.firefox-addons.web-clipper-obsidian
    # pkgs.nur.repos.rycee.firefox-addons.keepassxc-browser
    # only missing enhancer-for-youtube
    # pkgs.nur.repos.rycee.firefox-addons.enhancer-for-youtube
      ### BASICS ###
      # rycee.darkreader
      # # rycee.tree-style-tab
      # rycee.tab-stash
      # rycee.translate-web-pages
      #
      # ### PERFORMANCE ###
      # rycee.auto-tab-discard
      #
      # ### BLOCKING ###
      # # Enable "Annoyances" lists in uBO instead
      # # rycee.i-dont-care-about-cookies
      # rycee.user-agent-string-switcher
      # # rycee.gaoptout
      # # rycee.clearurls
      # # rycee.disconnect
      # # rycee.libredirect
      #
      # ### GITHUB ###
      # # bandithedoge.gitako
      # bandithedoge.sourcegraph
      # # rycee.enhanced-github
      # # rycee.refined-github
      # rycee.lovely-forks
      # # rycee.octolinker
      # # rycee.octotree
      #
      # ### YOUTUBE ###
      # rycee.sponsorblock
      # rycee.return-youtube-dislikes
      # # rycee.enhancer-for-youtube
      #
      # ### TWITCH ###
      # spikespaz.twitch-auto-clicker
      # # For Twitch, it is also worth considering removing the extension and just using uBO.
      # # <https://github.com/pixeltris/TwitchAdSolutions>
      # spikespaz.ttv-lol-pro
      # spikespaz.frankerfacez
      #
      # ### NEW INTERNET ###
      # # rycee.ipfs-companion
      #
      # ### FIXES ###
      # # rycee.open-in-browser
      # # rycee.no-pdf-download
      # # rycee.don-t-fuck-with-paste
      #
      # ### UTILITIES ###
      # rycee.video-downloadhelper
      # # rycee.export-tabs-urls-and-titles
      # # rycee.markdownload
      # # rycee.flagfox
      # rycee.keepassxc-browser
      # rycee.wappalyzer
      # # slaier.dictionary-anywhere
      # spikespaz.pwas-for-firefox
    ];
  };
}
