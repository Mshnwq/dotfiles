{ config, pkgs, lib, ... }: {
  home.activation.wrapDesktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.dataHome}/applications"
    mkdir -p "${config.xdg.dataHome}/flatpak"
    mkdir -p "${config.xdg.dataHome}/flatpak/overrides"

    # --- Flatpak Override ---
    winezgui_override_file="${config.xdg.dataHome}/flatpak/overrides/io.github.fastrizwaan.WineZGUI"
    if [ ! -f "$winezgui_override_file" ]; then
      echo -e "[Context]\nsockets=wayland" > "$winezgui_override_file"
    fi
  '';
}
