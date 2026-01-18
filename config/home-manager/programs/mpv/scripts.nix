# programs/mpv/scripts.nix
{
  lib,
  pkgs,
  ...
}:
let
  # https://github.com/stax76/awesome-mpv
  plugins = {
    mpv_thumbnail_script =
      let
        baseUrl = "https://github.com/marzzzello/mpv_thumbnail_script/releases/download/0.5.4";
      in
      {
        script = [
          {
            url = "${baseUrl}/mpv_thumbnail_script_client_osc.lua";
            hash = "sha256-jR4mEp5fVbpg4WoyKSGA6ediJmEHheLYPhCuAqYv4vM=";
          }
          {
            url = "${baseUrl}/mpv_thumbnail_script_server.lua";
            hash = "sha256-z68RiE3j7CAmnv0gHiP9tBvmiQC8el+hgNU98JXOit8=";
          }
        ];
        opts = ''
          mpv_no_sub=yes
          mpv_hr_seek=yes
          thumbnail_width=200
          thumbnail_height=200
          min_delta=5
          max_delta=90
          # Remote options
          remote_autogenerate_max_duration=1200
          remote_thumbnail_count=60
          remote_min_delta=15
          remote_max_delta=120
          storyboard_enable=no
          storyboard_upscale=no
          # Display options
          vertical_offset=24
          pad_top=10
          pad_bot=0
          pad_left=10
          pad_right=10
          pad_in_screenspace=yes
          offset_by_pad=yes
          background_color=000000
          background_alpha=80
          constrain_to_screen=yes
          hide_progress=yes
        '';
      };

    visualizer = {
      script = {
        url = "https://raw.githubusercontent.com/mfcc64/mpv-scripts/master/visualizer.lua";
        hash = "sha256-l4gyed5seiXDOFp8UhGNpwUowmSpU6HXGqwRBwtJFG0=";
      };
      opts = ''
        forcewindow=true
        mode=novideo
        name=showcqt
        quality=low
        height=8
      '';
    };
  };

  mkScriptFiles =
    plugins:
    lib.foldl' (
      acc: pluginName:
      let
        plugin = plugins.${pluginName};
        scriptList =
          if builtins.isList plugin.script then plugin.script else [ plugin.script ];
      in
      acc
      // lib.listToAttrs (
        map (
          scriptDef:
          let
            fileName = builtins.baseNameOf scriptDef.url;
          in
          lib.nameValuePair ".config/mpv/scripts/${fileName}" {
            source = pkgs.fetchurl scriptDef;
          }
        ) scriptList
      )
    ) { } (builtins.attrNames plugins);
  mkScriptOpts =
    plugins:
    lib.mapAttrs' (
      name: plugin:
      lib.nameValuePair ".config/mpv/script-opts/${name}.conf" { text = plugin.opts; }
    ) (lib.filterAttrs (_: plugin: plugin ? opts) plugins);
in
{
  files = lib.mkMerge [
    (mkScriptFiles plugins)
    (mkScriptOpts plugins)
  ];
}
