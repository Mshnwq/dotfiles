# programs/claude/default.nix
{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # claude-desktop (from /overlays, the aaddrick build) ships the official app
  # tree as-is with no theming hook. We patch its Electron main process to inject
  # pywal colors into every window's CSS at runtime — see ./pywal-theme.js. This
  # unpacks resources/app.asar, prepends the injector to the main entry
  # (.vite/build/index.pre.js, which starts with `"use strict";`), and repacks,
  # re-unpacking the two native *.node modules that must live outside the asar.
  claude-desktop-pywal = pkgs.claude-desktop.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.asar ];
    postInstall = (old.postInstall or "") + ''
      resources="$out/lib/claude-desktop/resources"
      chmod -R u+w "$resources"
      work=$(mktemp -d)
      asar extract "$resources/app.asar" "$work"
      idx="$work/.vite/build/index.pre.js"
      if [ "$(head -c 13 "$idx")" != '"use strict";' ]; then
        echo "claude pywal patch: unexpected main-entry prefix, aborting" >&2
        exit 1
      fi
      # Inject right after the leading strict directive so it stays first.
      tail -c +14 "$idx" > "$work/rest.js"
      {
        printf '%s\n' '"use strict";'
        cat ${./pywal-theme.js}
        printf '\n'
        cat "$work/rest.js"
      } > "$idx.new"
      mv "$idx.new" "$idx"
      rm -f "$work/rest.js"
      rm -rf "$resources/app.asar" "$resources/app.asar.unpacked"
      asar pack "$work" "$resources/app.asar" --unpack "*.node"
      rm -rf "$work"
    '';
  });
  claude-desktop-fixed =
    inputs.claude-desktop.packages.x86_64-linux.default.overrideAttrs
      (old: {
        src =
          inputs.claude-desktop.packages.x86_64-linux.default.src.overrideAttrs
            (_: {
              #outputHash = "sha256-aNSPrzIIs/7fvlCVLRh4QX/igEf2m8SZly+R+3LqXGQ=";
              outputHash = "sha256-+0wfDiDg4gz3paQ+348efHy+30IGlLuItLOZitzC/Hc=";
            });
        # CLAUDE_NATIVE_TITLEBAR=1 makes the window use a native frame
        # (frame:true, no titleBarOverlay). The min/max/close buttons are the
        # Electron Window-Controls-Overlay — drawn by Chromium, not in the DOM,
        # so CSS can't hide them; this is the only real off-switch. On Hyprland
        # (no client-side titlebar) it means no window buttons at all.
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/claude-desktop --set CLAUDE_NATIVE_TITLEBAR 1
        '';
      });

  # The patrickjaja build themes via ~/.config/Claude/claude-desktop-bin.jsonc.
  # Generate a "pywal" theme in it from the current palette (see ./gen-theme.py).
  # Runs on switch; re-run after a `wal` change to re-theme (then restart the app).
  genPywalTheme = pkgs.writeShellScript "claude-desktop-pywal-theme" ''
    colors="${config.xdg.cacheHome}/wal/colors.json"
    out="${config.xdg.configHome}/Claude/claude-desktop-bin.jsonc"
    if [ -f "$colors" ]; then
      mkdir -p "${config.xdg.configHome}/Claude"
      ${pkgs.python3}/bin/python3 ${./gen-theme.py} "$colors" "$out"
    fi
  '';
in
{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
    # settings = {
    #   theme = "dark-ansi";
    # };
  };
  home.packages = with pkgs; [
    # claude-desktop-pywal # from /overlays, patched with ./pywal-theme.js
    # claude-desktop # from /overlays
    # TODO: patch https://github.com/patrickjaja/claude-desktop-bin/tree/master/themes
    # a theme into claude desktop
    # https://github.com/aaddrick/claude-desktop-debian/blob/main/nix/claude-desktop.nix
    # https://github.com/aaddrick/claude-desktop-debian/blob/main/nix/fhs.nix
    claude-desktop-fixed
    # TODO: find way to work with keyring (KWallet not gnome-keyring)
    claude-monitor # https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor
    # fff-mcp # from /pkgs
    # openclaw # needs sandboxing https://buduroiu.com/blog/openclaw-microvm/
  ];
  home.activation.claudeDesktopPywalTheme =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      "$DRY_RUN_CMD ${genPywalTheme}";
  programs.which-key = {
    entries = [
      {
        key = "c";
        desc = "Claude";
        cmd = "claude-desktop";
      }
    ];
  };
}
