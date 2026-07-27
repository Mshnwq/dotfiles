# programs/claude/default.nix
{
  config,
  pkgs,
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
    claude-desktop-pywal # from /overlays, patched with ./pywal-theme.js
    # TODO: patch https://github.com/patrickjaja/claude-desktop-bin/tree/master/themes
    # a theme into claude desktop
    # https://github.com/aaddrick/claude-desktop-debian/blob/main/nix/claude-desktop.nix
    # https://github.com/aaddrick/claude-desktop-debian/blob/main/nix/fhs.nix
    # claude-desktop # from /overlays
    # TODO: find way to work with keyring (KWallet not gnome-keyring)
    claude-monitor # https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor
    # fff-mcp # from /pkgs
    # openclaw # needs sandboxing https://buduroiu.com/blog/openclaw-microvm/
  ];
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
