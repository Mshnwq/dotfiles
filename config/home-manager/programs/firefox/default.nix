{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  profile = "mshnwq.default";
  profileName = "mshnwq";

  extensions = {
    rycee = pkgs.nur.repos.rycee.firefox-addons;
    custom = pkgs.callPackage ./addons.nix {
      inherit lib;
      inherit (inputs.firefox-addons.lib."x86_64-linux") buildFirefoxXpiAddon;
    };
  };
in
{

  xdg.desktopEntries.firefox-nix = {
    name = "Firefox (nix)";
    exec = "env MOZ_USE_XINPUT2=1 nixGLIntel firefox %u";
    icon = "firefox";
    categories = [
      "Network"
      "WebBrowser"
    ];
    type = "Application";
    startupNotify = true;
    mimeType = [
      "text/html"
      "text/xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "application/xhtml+xml"
      "application/xhtml_xml"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ];
  };

  # Custom wrapper for firefox
  home.file.".local/bin/Firefox".text = ''
    #!/usr/bin/env bash
    exec env MOZ_USE_XINPUT2=1 nixGLIntel firefox "$@"
  '';
  home.file.".local/bin/Firefox".executable = true;

  home.sessionVariables = {
    BROWSER = "firefox";
  };

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

      # other
      "browser.tabs.inTitlebar" = 0;
      "browser.tabs.warnOnClose" = true;
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "datareporting.usage.uploadEnabled" = "false";
      "datareporting.healthreport.logging.consoleEnabled" = false;
      "datareporting.healthreport.service.enabled" = false;
      "datareporting.healthreport.service.firstRun" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;

      # TODO: new tab page pin sites SOP secret
      "browser.newtabpage.pinned" =
        "[{\"url\":\"https://www.youtube.com/\",\"baseDomain\":\"youtube.com\"},{\"url\":\"https://chatgpt.com/\",\"baseDomain\":\"chatgpt.com\"},{\"url\":\"https://github.com/\",\"baseDomain\":\"github.com\"},{\"url\":\"https://www.reddit.com/\",\"baseDomain\":\"reddit.com\"}]";
    };

    extensions.packages =
      with extensions.rycee;
      [

        # MyFox Theme
        pywalfox # remove shortcut Ctrl+Alt+D
        sidebery # remove Ctrl+E and import settings from dotfiles
        userchrome-toggle-extended # manually add shortcuts  1: Ctrl+E 2: Ctrl+Alt+S 3: Ctrl+Alt+H 4: Ctrl+Alt+C

        pwas-for-firefox # idk

        # Useful utilities

        # aria2-integration
        # buster-captcha-solver

        darkreader
        clearurls
        sponsorblock
        return-youtube-dislikes
        videospeed
        search-by-image

        # unfree extensions - manually allowed
        (untrap-for-youtube.override { meta.license.free = true; }) # import it from dotfiles
        (video-downloadhelper.override { meta.license.free = true; }) # TODO: install daemon
        (tampermonkey.override { meta.license.free = true; }) # TODO: import scripts from dotfiles SOP secrets

        # TODO:
        # rycee.web-clipper-obsidian
        # rycee.keepassxc-browser

        # only missing enhancer-for-youtube  # Discontinued :(
      ]
      ++ (with extensions.custom; [
        duplicate-tab-shortcut # change default shortcut Ctrl+Alt+D
      ]);
  };

  programs.firefox.profiles."mshnwq.job" = {
    id = 1;
    isDefault = false;
    name = "job";

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

      # other
      "browser.tabs.inTitlebar" = 0;
      "browser.tabs.warnOnClose" = true;
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "datareporting.usage.uploadEnabled" = "false";
      "datareporting.healthreport.logging.consoleEnabled" = false;
      "datareporting.healthreport.service.enabled" = false;
      "datareporting.healthreport.service.firstRun" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
    };

    extensions.packages =
      with extensions.rycee;
      [
        sidebery # remove Ctrl+E and import settings from dotfiles
        darkreader
        clearurls
        search-by-image
      ]
      ++ (with extensions.custom; [
        duplicate-tab-shortcut # change default shortcut Ctrl+Alt+D
      ]);
  };
}
