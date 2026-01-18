# programs/mpv/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  hasNvidia =
    builtins.pathExists /etc/bazzite/image_name
    && lib.strings.hasInfix "nvidia" (builtins.readFile /etc/bazzite/image_name);
  scripts = import ./scripts.nix { inherit pkgs lib; };
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
      [ "mesa" ];

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

  # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.mpv.enable
  programs.mpv = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.mpv;
    # bindings = {
    #   "r" = "cycle_values video-rotate 90 180 270 0";
    #   "|" = "vf toggle vflip";
    # };
    config = {
      # osd-level = 0;
      hwdec = "vaapi";
      title = "\${filename}";
    };
    # overridden by programs.mpv.config.
    defaultProfiles = [
      "default"
      "minimal"
    ];
    profiles = {
      default = {
      };
      minimal = {
        load-scripts = "no";
      };
      music = {
        osd-level = 0;
        force-window = "yes";
      };
    };
    # extraInput = "";
    # includes = "";
  };

  home.file = scripts.files;
  # imports = [
  #   (lib.nixgl.mkNixGLWrapper {
  #     name = "Mpv";
  #     command = "mpv";
  #     nixGLVariant = "nixGLIntel";
  #   })
  # ];
  # TODO: shaders
}
