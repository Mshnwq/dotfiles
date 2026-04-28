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
      # jellyfin-mpv-shim
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
      uosc
      thumbfast
      mpvacious
      videoclip
      occivink.crop
    ];
    includes = [
      "~~/themes/pywal.conf"
    ];
    extraInput = ''
      alt+c script-message-to crop start-crop soft
    '';
    bindings = {
      "R" = "cycle_values video-rotate 90 180 270 0";
      "L" = "cycle-values loop-file \"inf\" \"no\"";
      "H" = "cycle-values hwdec \"auto\" \"no\"";
      "|" = "vf toggle vflip";
      "P" =
        ''script-message cycle-commands/osd "apply-profile transparent" "apply-profile default"'';
    };
    # overrides profiles
    config = {
      osc = "no";
      osd-level = 0;
      # vaapi with i965 too hot
      hwdec = "vaapi-copy"; # i hate you
      title = "\${filename}";
      vo = "gpu"; # use gpu instead of gpu-next
      gpu-api = "opengl"; # skip vulkan entirely
    };
    defaultProfiles = [
      "transparent"
    ];
    # https://github.com/mpv-player/mpv/issues/13257
    profiles = {
      # https://github.com/mpv-player/mpv/issues/6590
      transparent = {
        background-color = "0/0";
        background = "none";
      };
      # NOT POSSIBLE i guess make a seperat script of Mpv-Anki?
      # https://github.com/mpv-player/mpv/issues/14475
      # anki = {
      #   "input-commands" =
      #     "load-script '${pkgs.mpvScripts.mpvacious}/share/mpv/scripts/mpvacious'";
      # };
      # https://www.reddit.com/r/mpv/comments/1149cpm/recommended_profiles/
    };
  };

  imports = [
    (lib.nixgl.mkNixGLWrapper {
      name = "Mpv";
      command = "mpv";
      nixGLVariant = "nixGLIntel";
      # envVars = "LIBVA_DRIVER_NAME=\"i965\"";
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
              (builtins.readFile "${pkgs.mpv-unwrapped}/share/applications/mpv.desktop");
        };
    }
  ];
}
