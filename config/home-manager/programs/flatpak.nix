{
  inputs,
  config,
  ...
}:
{
  home.activation.wrapDesktop =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        mkdir -p "${config.xdg.dataHome}"/{applications,flatpak/overrides}

        # --- Flatpak Override ---
        winezgui_override="${config.xdg.dataHome}/flatpak/overrides/io.github.fastrizwaan.WineZGUI"
        if [ ! -f "$winezgui_override" ]; then
          cat > "$winezgui_override" <<EOF
        [Context]
        sockets=wayland
        EOF
        fi
      '';
}
