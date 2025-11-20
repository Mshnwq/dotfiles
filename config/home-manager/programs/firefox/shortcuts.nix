profile:
{
  config,
  ...
}:
let
  cfg = config.programs.firefox;
in
{
  home.file."${cfg.profilesPath}/${profile}/extension-settings.json" = {
    force = true;
    text = builtins.toJSON {
      "version" = 3;
      "commands" = {
        "1" = {
          "precedenceList" = [
            {
              "id" = "userchrome-toggle-extended@n2ezr.ru";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+E";
              };
              "enabled" = true;
            }
          ];
        };
        "2" = {
          "precedenceList" = [
            {
              "id" = "userchrome-toggle-extended@n2ezr.ru";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+Alt+S";
              };
              "enabled" = true;
            }
          ];
        };
        "3" = {
          "precedenceList" = [
            {
              "id" = "userchrome-toggle-extended@n2ezr.ru";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+Alt+H";
              };
              "enabled" = true;
            }
          ];
        };
        "4" = {
          "precedenceList" = [
            {
              "id" = "userchrome-toggle-extended@n2ezr.ru";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+Alt+C";
              };
              "enabled" = true;
            }
          ];
        };
        "enable_dark_mode" = {
          "precedenceList" = [
            {
              "id" = "pywalfox@frewacom.org";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "";
              };
              "enabled" = true;
            }
          ];
        };
        "duplicate-tab" = {
          "precedenceList" = [
            {
              "id" = "duplicate-tab@firefox.stefansundin.com";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+Alt+D";
              };
              "enabled" = true;
            }
          ];
        };
        "_execute_sidebar_action" = {
          "precedenceList" = [
            {
              "id" = "{3c078156-979c-498b-8990-85f7987dd929}";
              "installDate" = 1000;
              "value" = {
                "shortcut" = "Ctrl+Alt+E";
              };
              "enabled" = true;
            }
          ];
        };
      };
      "prefs" = {
        "privacy.containers" = {
          "initialValue" = { };
          "precedenceList" = [
            {
              "id" = "{3c078156-979c-498b-8990-85f7987dd929}";
              "installDate" = 1000;
              "value" = "{3c078156-979c-498b-8990-85f7987dd929}";
              "enabled" = true;
            }
            {
              "id" = "{12cf650b-1822-40aa-bff0-996df6948878}";
              "installDate" = 1000;
              "value" = "{12cf650b-1822-40aa-bff0-996df6948878}";
              "enabled" = true;
            }
          ];
        };
        "network.networkPredictionEnabled" = {
          "initialValue" = { };
          "precedenceList" = [
            {
              "id" = "{b86e4813-687a-43e6-ab65-0bde4ab75758}";
              "installDate" = 1000;
              "value" = false;
              "enabled" = true;
            }
            {
              "id" = "uBlock0@raymondhill.net";
              "installDate" = 1000;
              "value" = false;
              "enabled" = true;
            }
          ];
        };
        "websites.hyperlinkAuditingEnabled" = {
          "initialValue" = { };
          "precedenceList" = [
            {
              "id" = "uBlock0@raymondhill.net";
              "installDate" = 1000;
              "value" = false;
              "enabled" = true;
            }
          ];
        };
      };
      "url_overrides" = { };
      "default_search" = { };
      "tabHideNotification" = { };
      "homepageNotification" = { };
      "newTabNotification" = { };
    };
  };
}
