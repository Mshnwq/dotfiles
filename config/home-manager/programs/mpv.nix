# programs/mpv.nix
{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # https://home-manager.dev/manual/24.11/index.xhtml#sec-usage-gpu-non-nixos
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [
    "mesa"
    "nvidiaPrime"
  ];

  home.packages = with pkgs; [
    jellyfin-mpv-shim
    # NOTE:run with --impure flag
    nixgl.auto.nixGLDefault
    nixgl.auto.nixGLNvidia
    nixgl.nixGLIntel
  ];

  programs.mpv = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.mpv;
  };
}
