# programs/hypr.nix
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hyprConfDir = "${config.xdg.configHome}/hypr/conf.d";
in
{
  home.packages = with pkgs; [
    awww
    grim
    slurp
    swappy
    waybar
    # woomer
    niflveil # from /pkgs/;
    hypridle
    # hyprlock TODO: broken
    hyprsunset
    hyprpicker
    libinput-gestures
    # TODO: quickshell
  ];

  home.file.".config/libinput-gestures.conf".text =
    let
      gswipe =
        action: fingers: cmd:
        "gesture swipe ${action}\t${toString fingers} ${cmd}";
    in
    ''
      ${gswipe "up" 3 "niflveil restore-last"}
      ${gswipe "down" 3 "niflveil minimize"}
    '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap hyprPkgs.hyprland;
    portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    extraConfig =
      let
        layoutConfigContent =
          builtins.readFile
            config.sops.secrets."keyboard-conf".path;
        # Parse lines and extract layout codes (values after =)
        parseLayouts =
          content:
          let
            lines = lib.splitString "\n" content;
            # Filter out empty lines and comments
            validLines = builtins.filter (
              line: line != "" && !(lib.hasPrefix "#" (lib.trim line))
            ) lines;
            # Extract the part after = and trim whitespace
            extractCode =
              line:
              let
                parts = lib.splitString "=" line;
              in
              if builtins.length parts >= 2 then lib.trim (builtins.elemAt parts 1) else "";
            codes = map extractCode validLines;
            # Filter out empty codes
            validCodes = builtins.filter (code: code != "") codes;
          in
          lib.concatStringsSep "," validCodes;
        kbLayouts = parseLayouts layoutConfigContent;
        confFiles =
          let
            dir = builtins.readDir hyprConfDir;
          in
          builtins.filter (
            file: dir.${file} == "regular" && builtins.match ".*\\.conf$" file != null
          ) (builtins.attrNames dir);
        confSources = lib.concatStringsSep "\n" (
          map (file: "source = ${hyprConfDir}/${file}") confFiles
        );
      in
      ''
        exec-once = dbus-update-activation-environment --systemd --all
        exec-once = /usr/bin/lxpolkit
        ${confSources}
        input {
            kb_layout=${kbLayouts}
        }
      '';
  };

  sops.secrets = {
    keyboard-conf = {
      mode = "0400";
      path = "${config.xdg.configHome}/keyboard_layouts.conf";
    };
  };

  # imports = [
  #   (lib.which-key.mkMenu {
  #   })
  # ];
  # https://www.vimjoyer.com/vid74-which-key
  # home.file.".config/wlr-which-key/config.yaml".text =
  #   let
  #     colorsPath = "${config.xdg.cacheHome}/wal/colors";
  #     lines =
  #       if builtins.pathExists colorsPath then
  #         lib.strings.splitString "\n" (builtins.readFile colorsPath)
  #       else
  #         [ ];
  #     getOr =
  #       index: fallback:
  #       if builtins.length lines > index then builtins.elemAt lines index else fallback;
  #   in
  #   ''
  #     background: "${getOr 0 "#0d0d1f"}88"
  #     border: "${getOr 8 "#5c5c71"}"
  #     color: "${getOr 7 "#c2c2c7"}"
  #     font: JetBrainsMono Nerd Font 12
  #     anchor: top-left
  #     margin_right: 0
  #     margin_bottom: 0
  #     margin_left: 20
  #     margin_top: 20
  #     separator: " ➜ "
  #     border_width: 1.5
  #     corner_r: 5
  #     padding: 20
  #     rows_per_column: 4
  #     column_padding: 20
  #     auto_kbd_layout: true
  #     menu:
  #       - key: "o"
  #         desc: Obsidian
  #         cmd: gtk-launch obsidian
  #       - key: "t"
  #         desc: Translate
  #         submenu:
  #           - key: "x"
  #             desc: Extract
  #             cmd: ~/.local/bin/executer/.gtt.sh --extract
  #           - key: "a"
  #             desc: Anki
  #             cmd: ~/.local/bin/executer/.gtt.sh --anki
  #       - key: "x"
  #         desc: Executer
  #         submenu:
  #           - key: "d"
  #             desc: Daemons
  #             cmd: ~/.local/bin/Executer --daemons
  #           - key: "p"
  #             desc: Procs
  #             cmd: ~/.local/bin/Executer --procs
  #           - key: "v"
  #             desc: VPN
  #             cmd: ~/.local/bin/Executer --vpn
  #           - key: "w"
  #             desc: Wal
  #             cmd: ~/.local/bin/Executer --wal
  #   '';
}
