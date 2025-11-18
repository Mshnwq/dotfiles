# programs/mpv.nix
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  hasNvidia =
    builtins.pathExists /etc/bazzite/image_name
    && lib.strings.hasInfix "nvidia" (builtins.readFile /etc/bazzite/image_name);
in
{
  # https://home-manager.dev/manual/24.11/index.xhtml#sec-usage-gpu-non-nixos
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = lib.mkIf hasNvidia "nvidiaPrime";
  nixGL.installScripts =
    if hasNvidia then
      [
        "mesa"
        "nvidiaPrime"
      ]
    else
      [
        "mesa"
      ];

  home.packages =
    with pkgs;
    [
      jellyfin-mpv-shim
      # NOTE: run with --impure flag
      nixgl.auto.nixGLDefault
      nixgl.nixGLIntel
    ]
    ++ lib.optionals hasNvidia [
      nixgl.auto.nixGLNvidia
    ];

  # https://home-manager.dev/manual/24.11/options.xhtml#opt-programs.mpv.enable
  programs.mpv = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.mpv;
    config = {
      # osd-level = 0;
      title = "\${filename}";
      hwdec = "vaapi";
    };
    bindings = {
      "r" = "cycle_values video-rotate 90 180 270 0";
      "|" = "vf toggle hflip";
    };
  };
}
