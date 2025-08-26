{ config, pkgs, lib, ... }: {
  home.activation.linkWalTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.dataHome}/applications"
    mkdir -p "${config.xdg.dataHome}/flatpak"
    mkdir -p "${config.xdg.dataHome}/flatpak/overrides"

    # ---- Fix Electron Flatpaks ----
    # --- Discord Desktop Entry ---
    discord_desktop="${config.xdg.dataHome}/applications/com.discordapp.Discord.desktop"
    if [ ! -f "$discord_desktop" ]; then
      cp /var/lib/flatpak/app/com.discordapp.Discord/current/active/files/share/applications/com.discordapp.Discord.desktop "$discord_desktop"
      sed -i 's|^Exec=.*|Exec=/usr/bin/flatpak run com.discordapp.Discord --socket=wayland --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations %U|' "$discord_desktop"
    fi

    # --- Obsidian Flatpak Override ---
    obsidian_override_file="${config.xdg.dataHome}/flatpak/overrides/md.obsidian.Obsidian"
    if [ ! -f "$obsidian_override_file" ]; then
      tee "$override_file" <<'EOL'
      [Context]
      sockets=wayland
      EOL
    fi

    # ---- Fix nixGL wrappers ----
    # --- KTailctl Desktop Entry ---
    ktailctl_desktop="${config.xdg.dataHome}/applications/org.fkoehler.KTailctl.desktop"
    if [ ! -f "$ktailctl_desktop" ]; then
      cp ${pkgs.ktailctl}/share/applications/org.fkoehler.KTailctl.desktop "$ktailctl_desktop"
      sed -i 's|^Exec=.*|Exec=nixGL ktailctl|' "$ktailctl_desktop"
    fi
  '';
}
