# programs/mpv/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  default = "mesa";
  hasNvidia =
    builtins.pathExists /etc/bazzite/image_name
    && lib.strings.hasInfix "nvidia" (builtins.readFile /etc/bazzite/image_name);
  scripts = import ./scripts.nix { inherit pkgs lib; };
in
{
  # https://home-manager.dev/manual/24.11/index.xhtml#sec-usage-gpu-non-nixos
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = default;
  nixGL.offloadWrapper = lib.mkIf hasNvidia "nvidiaPrime";
  nixGL.installScripts = [ default ] ++ lib.optional hasNvidia "nvidiaPrime";

  home.packages =
    with pkgs;
    [
      jellyfin-mpv-shim
      nixgl.auto.nixGLDefault
      nixgl.nixGLIntel
    ]
    ++ lib.optionals hasNvidia [
      nixgl.auto.nixGLNvidia
    ];

  # https://wiki.archlinux.org/title/Mpv
  # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.mpv.enable
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      occivink.crop
      visualizer
      thumbfast
      uosc
      # mpvacious
    ];
    extraInput = ''
      alt+c script-message-to crop start-crop soft
    '';
    bindings = {
      "r" = "cycle_values video-rotate 90 180 270 0";
      # "|" = "vf toggle vflip";
    };
    config = {
      osc = "no";
      osd-level = 0;
      hwdec = "vaapi";
      title = "\${filename}";
    };
    # overridden by programs.mpv.config.
    # defaultProfiles = [
    # "default"
    # "minimal"
    # ];
    # https://github.com/mpv-player/mpv/issues/13257
    # https://www.reddit.com/r/mpv/comments/1149cpm/recommended_profiles/
    # profiles = {
    #   default = {
    #     osd-level = 0;
    #     osc = "no";
    #   };
    #   minimal = {
    #     load-scripts = "no";
    #   };
    #   music = {
    #     osd-level = 0;
    #     # force-window = "yes";
    #   };
    # };
    # includes = "";
  };

  imports = [
    (lib.nixgl.mkNixGLWrapper {
      name = "Mpv";
      command = "mpv";
      nixGLVariant = "nixGLIntel";
    })
  ];
  home.file = lib.mkMerge [
    scripts.files
    {
      ".local/share/applications/mpv.desktop" =
        let
          MPV = "${config.home.homeDirectory}/.local/bin/Mpv";
        in
        {
          force = true;
          text =
            builtins.replaceStrings
              [ "TryExec=mpv" "Exec=mpv" ]
              [ "TryExec=${MPV}" "Exec=${MPV}" ]
              (builtins.readFile "${pkgs.mpv}/share/applications/mpv.desktop");
        };
    }
  ];
  # TODO: https://github.com/catppuccin/mpv
}
