# programs/mpv/scripts.nix
{
  lib,
  pkgs,
  ...
}:
let
  # https://github.com/stax76/awesome-mpv
  plugins = {
    # https://github.com/tomasklaen/uosc
    uosc = {
      # https://github.com/tomasklaen/uosc/blob/main/src/uosc.conf
      opts = ''
        controls=menu,items,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,gap,space,space,<video,audio>speed,loop-file
        timeline_style=bar
        timeline_size=20
        #color=
        #progress=never how off on full screen?
        progress=always
        controls_size=24
        volume_size=30
        speed_persistency=windowed
        menu_type_to_search=no
        window_border_size=1
        font_scale=1
        text_border=1.2
        border_radius=4
        opacity=slider=0.5,slider_gauge=0.5,speed=0.3
        animation_duration=100
        flash_duration=10
        proximity_in=40
        proximity_out=120
        destination_time=total
        buffered_time_threshold=0
        autohide=yes
        pause_indicator=manual
        stream_quality_options=720,480,360,240,144
        adjust_osd_margins=yes
        disable_elements=window_border,top_bar,audio_indicator
      '';
    };

    # https://github.com/po5/thumbfast
    thumbfast = {
      opts = ''
        quit_after_inactivity=0
        max_height=200
        max_width=200
        overlay_id=42
        spawn_first=no
      '';
    };

    # https://github.com/mfcc64/mpv-scripts
    visualizer = {
      # https://raw.githubusercontent.com/mfcc64/mpv-scripts/master/visualizer.lua
      opts = ''
        name=avectorscope
        forcewindow=true
        #mode=noalbumart
        mode=novideo
        quality=low
        height=12
      '';
    };

    # https://github.com/Ajatt-Tools/mpvacious
    subs2srs = {
      # https://github.com/Ajatt-Tools/mpvacious/blob/master/.github/RELEASE/subs2srs.conf
      opts = ''
        ankiconnect_url=127.0.0.1:8765
        # https://github.com/alyssabedard/mpv2anki/blob/master/docs/note_types/basic/Sentence%20Mining.apkg
        model_name=mpv2anki
        sentence_field=Translation
        audio_field=SentenceAudio
        image_field=Screenshot
        secondary_field=Sentence
        use_forvo=no
        secondary_sub_auto_load=yes
        secondary_sub_lang=eng,en
        # Default binding to cycle this value: Ctrl+v.
        secondary_sub_visibility=auto
      '';
    };

    # https://github.com/oltodosel/interSubs
  };

  mkScriptFiles =
    plugins:
    lib.foldl' (
      acc: pluginName:
      let
        plugin = plugins.${pluginName};
        # Only process if plugin has a script attribute
        hasScript = plugin ? script;
      in
      if !hasScript then
        acc
      else
        let
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
# TODO: shaders?
