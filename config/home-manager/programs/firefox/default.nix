{
  lib,
  inputs,
  config,
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
  xdg.desktopEntries.firefox = {
    name = "Firefox";
    exec = "Firefox %u";
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

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  # only need pywalfax --install and sidebery load addons and untrap
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox;

  imports = [
    (import ./blocking.nix profile)
    (import ./shyfox.nix profile)
    (lib.nixgl.mkNixGLWrapper {
      name = "Firefox";
      command = "firefox";
      nixGLVariant = "nixGLIntel";
      envVars = "LIBVA_DRIVER_NAME=\"i965\" MOZ_USE_XINPUT2=1";
    })
  ];

  home.packages = [ pkgs.firefoxpwa ];
  programs.firefox.nativeMessagingHosts = [ pkgs.firefoxpwa ];

  programs.firefox.profiles.${profile} = {
    id = 0;
    isDefault = true;
    name = profileName;

    # Clobber unconditionally, `./search-engines.nix` is source of truth.
    search.force = true;
    search.default = "ddg";
    search.engines = import ./search-engines.nix { inherit lib; };

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
      # Don't show blue dot to notify about AI chat.
      "sidebar.notification.badge.aichat" = false;

      "browser.newtabpage.pinned" =
        builtins.readFile
          config.sops.secrets."browser-pinned".path;

      "browser.shell.checkDefaultBrowser" = false;
      "browser.download.autohideButton" = false;

      # No sponsored suggestions.
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;

      # Allow playing DRM-controlled content.
      "media.eme.enabled" = true;

      # Tell websites not to sell or share my data.
      "privacy.globalprivacycontrol.enabled" = true;

      # Disable "Firefox Labs" because I'm afraid of it messing with extensions and user chrome.
      # Note that `enabled = false` is the correct value to disable, despite being named "opt-out".
      "app.shield.optoutstudies.enabled" = false;

      # <https://wiki.archlinux.org/title/Firefox#XDG_Desktop_Portal_integration>
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.open-uri" = 1;

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
        # MyFox Theme
        pywalfox # remove shortcut Ctrl+Alt+D
        sidebery # remove Ctrl+E and import settings from dotfiles
        userchrome-toggle-extended # manually add shortcuts  1: Ctrl+E 2: Ctrl+Alt+S 3: Ctrl+Alt+H 4: Ctrl+Alt+C
        pwas-for-firefox # idk
        # Useful utilities
        # aria2-integration
        # buster-captcha-solver
        # other helpful
        darkreader
        clearurls
        sponsorblock
        return-youtube-dislikes
        videospeed
        search-by-image
        cookies-txt
        # unfree extensions - manually allowed
        (untrap-for-youtube.override {
          meta.license.free = true;
        }) # import it from dotfiles
        (tampermonkey.override {
          meta.license.free = true;
        }) # Important: Under the tampermonkey settings, set the Config mode to Advanced and enable the Browser API in Download Mode (BETA). then import scripts from sops
        # TODO:
        # web-clipper-obsidian
        # keepassxc-browser
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
