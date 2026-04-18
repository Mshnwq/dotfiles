# modules/which-key.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.which-key;

  entryType = lib.types.submodule {
    options = {
      key = lib.mkOption { type = lib.types.str; };
      desc = lib.mkOption { type = lib.types.str; };
      cmd = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      submenu = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf entryType);
        default = null;
      };
    };
  };

  entryToYAML =
    indent: entry:
    let
      pad = lib.strings.replicate indent " ";
    in
    ''
      ${pad}- key: "${entry.key}"
      ${pad}  desc: ${entry.desc}
    ''
    + lib.optionalString (entry.cmd != null) ''
      ${pad}  cmd: ${entry.cmd}
    ''
    + lib.optionalString (entry.submenu != null) (
      ''
        ${pad}  submenu:
      ''
      + lib.concatStrings (map (entryToYAML (indent + 4)) entry.submenu)
    );
in
{
  options.programs.which-key = {
    enable = lib.mkEnableOption "which-key";
    entries = lib.mkOption {
      type = lib.types.listOf entryType;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wlr-which-key ];
    home.file.".config/wlr-which-key/config.yaml" = {
      force = true; # because wal
      text =
        let
          colorsPath = "${config.xdg.cacheHome}/wal/colors";
          lines =
            if builtins.pathExists colorsPath then
              lib.strings.splitString "\n" (builtins.readFile colorsPath)
            else
              [ ];
          getOr =
            index: fallback:
            if builtins.length lines > index then builtins.elemAt lines index else fallback;
        in
        ''
          background: "${getOr 0 "#0d0d1f"}88"
          border: "${getOr 8 "#5c5c71"}"
          color: "${getOr 7 "#c2c2c7"}"
          font: JetBrainsMono Nerd Font 12
          anchor: top-left
          margin_right: 0
          margin_bottom: 0
          margin_left: 20
          margin_top: 20
          separator: " ➜ "
          border_width: 1.5
          corner_r: 5
          padding: 20
          rows_per_column: 6
          column_padding: 20
          auto_kbd_layout: true
          menu:
        ''
        + lib.concatStrings (map (entryToYAML 2) cfg.entries);
    };
  };
}
