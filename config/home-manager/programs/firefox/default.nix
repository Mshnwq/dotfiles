{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  profile = "mshnwq.default";
  profileName = "mshnwq";
  profile2 = "mshnwq.dummy";
  profileName2 = "dummy";
  extensions = {
    rycee = pkgs.nur.repos.rycee.firefox-addons;
    custom = pkgs.callPackage ./addons.nix {
      inherit lib;
      inherit (inputs.firefox-addons.lib."x86_64-linux") buildFirefoxXpiAddon;
    };
  };
  browser-pinned =
    if
      config.sops.secrets ? "browser-pinned"
      && builtins.pathExists config.sops.secrets."browser-pinned".path
    then
      builtins.readFile config.sops.secrets."browser-pinned".path
    else
      ''[{"url":"https://www.youtube.com/","baseDomain":"youtube.com"},{"url":"https://github.com/","baseDomain":"github.com"}]'';

  commonSettings = {
    # https://github.com/nix-community/home-manager/pull/6389
    "extensions.webextensions.ExtensionStorageIDB.enabled" = false;
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
    "browser.shell.checkDefaultBrowser" = false;
    "browser.download.autohideButton" = false;
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
in
{
  sops.secrets = {
    browser-pinned.mode = "0400";
    tampermonkey = {
      mode = "0400";
      path = "${config.xdg.configHome}/tampermonkey.txt";
    };
  };

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

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox;

  imports = [
    (import ./blocking.nix profile)
    (import ./youtube.nix profile)
    (import ./shyfox.nix profile)
    (import ./shortcuts.nix profile)
    (import ./shyfox.nix profile2)
    (import ./shortcuts.nix profile2)
    (lib.nixgl.mkNixGLWrapper {
      name = "Firefox";
      command = "firefox";
      nixGLVariant = "nixGLIntel";
      # libva is needed for intel vaapi Hardware decoding
      envVars = "LIBVA_DRIVER_NAME=\"i965\" DISPLAY=\"\" MOZ_ENABLE_WAYLAND=1 MOZ_USE_XINPUT2=1";
    })
  ];

  home.packages = [ pkgs.firefoxpwa ];
  programs.firefox.nativeMessagingHosts = [
    pkgs.firefoxpwa
    # pkgs.ff2mpv
  ];

  programs.firefox.profiles.${profile} = {
    id = 0;
    isDefault = true;
    name = profileName;

    search.force = true;
    search.default = "ddg";
    search.engines = import ./search-engines.nix { inherit lib; };
    settings = commonSettings // {
      "browser.newtabpage.pinned" = "${browser-pinned}";
      "network.protocol-handler.expose.obsidian" = false;
    };

    extensions.force = true;
    extensions.packages =
      with extensions.rycee;
      [
        clearurls
        cookies-txt
        search-by-image
        pwas-for-firefox
        keepassxc-browser
        web-clipper-obsidian
        (tampermonkey.override {
          meta.license.free = true;
        })
      ]
      ++ (with extensions.custom; [
        duplicate-tab-shortcut
      ]);
  };

  programs.firefox.profiles.${profile2} = {
    id = 1;
    isDefault = false;
    name = profileName2;
    settings = commonSettings;
    extensions.force = true;
    extensions.packages =
      with extensions.rycee;
      [
        clearurls
        search-by-image
        keepassxc-browser
        web-clipper-obsidian
      ]
      ++ (with extensions.custom; [
        duplicate-tab-shortcut
      ]);
  };
}
