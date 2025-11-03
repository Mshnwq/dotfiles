{
  lib,
  buildFirefoxXpiAddon,
}:
{
  duplicate-tab-shortcut =
    let
      fileId = "4142678";
    in
    buildFirefoxXpiAddon rec {
      pname = "duplicate_tab_shortcut";
      version = "1.6.0";
      addonId = "duplicate-tab@firefox.stefansundin.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/${fileId}/${pname}-${version}.xpi";
      sha256 = "sha256-5IPzGb+tN1lGR6hzBdOWcRgR8JjUw4NW22kVpMr2svY=";
      meta = with lib; {
        homepage = "https://github.com/stefansundin/duplicate-tab#";
        description = "Press Alt+Shift+D to duplicate the current tab (Option+Shift+D on Mac). Shortcut is configurable.";
        license = licenses.gpl3;
        mozPermissions = [ "storage" ];
        platforms = platforms.all;
      };
    };

  # xxx = let
  #   fileId = "";
  # in buildFirefoxXpiAddon rec {
  #   pname = "";
  #   version = "x.x.x";
  #   addonId = "{}";
  #   url = "https://addons.mozilla.org/firefox/downloads/file/${fileId}/${pname}-${version}.xpi";
  #   sha256 = "";
  #   meta = with lib; {
  #     description = "";
  #     license = licenses.xxx;
  #     mozPermissions = [
  #       "xxx"
  #     ];
  #     platforms = platforms.all;
  #   };
  # };
}
