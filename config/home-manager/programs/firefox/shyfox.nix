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
  # home.file."${cfg.profilesPath}/${profile}/chrome".source = pkgs.shyfox;
  home.activation.shyfoxTheme =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        if [ ! -d "$HOME/.build/shyfox" ]; then
          ${pkgs.git}/bin/git clone https://github.com/mshnwq/shyfox $HOME/.build/shyfox
          ln -sf "$HOME/.build/shyfox/ShyFox" \
              "${cfg.profilesPath}/${profile}/chrome/ShyFox"
          ln -sf "$HOME/.build/shyfox/icons" \
              "${cfg.profilesPath}/${profile}/chrome/icons"
        fi
      '';
  programs.firefox.profiles.${profile} = {
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
