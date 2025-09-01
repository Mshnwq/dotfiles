{ lib, buildFirefoxXpiAddon }: {
  duplicate-tab-shortcut = let fileId = "4142678";
  in buildFirefoxXpiAddon rec {
    pname = "duplicate_tab_shortcut";
    version = "1.6.0";
    addonId = "{ea9e8433-1562-4e04-9a5d-bb1c0b0253cc}";
    url = "https://addons.mozilla.org/firefox/downloads/file/${fileId}/${pname}-${version}.xpi";
    hash = "";
    meta = with lib; {
      description = "Press Alt+Shift+D to duplicate the current tab (Option+Shift+D on Mac). Shortcut is configurable.";
      license = licenses.gpl3;
      mozPermissions = [
        "storage" 
      ];
      platforms = platforms.all;
    };
  };
}
