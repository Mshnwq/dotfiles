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
}
