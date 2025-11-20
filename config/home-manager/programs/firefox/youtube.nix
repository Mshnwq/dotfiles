profile:
{
  pkgs,
  ...
}:
let
  inherit (pkgs.nur.repos.rycee) firefox-addons;
in
{
  programs.firefox.profiles.${profile} = {
    extensions.packages = with firefox-addons; [
      videospeed
      sponsorblock
      return-youtube-dislikes
      (untrap-for-youtube.override {
        meta.license.free = true;
      })
    ];

    # untrap
    extensions.settings."{2662ff67-b302-4363-95f3-b050218bd72c}".force = true;
    extensions.settings."{2662ff67-b302-4363-95f3-b050218bd72c}".settings = {
      "untrap_shortcuts_disable_enable" = [
        "Control"
        "Alt"
        "u"
      ];
      "untrap_home_hide_banners_ads_with_close" = true;
      "untrap_home_hide_ads_first_slot" = true;
      "untrap_sidebar_hide_home_section" = false;
      "untrap_sidebar_hide_button_shorts" = true;
      "untrap_sidebar_hide_button_subscriptions" = false;
      "untrap_sidebar_hide_button_youtube_music" = true;
      "untrap_sidebar_hide_button_you" = true;
      "untrap_sidebar_hide_button_your_channel" = true;
      "untrap_sidebar_hide_button_history" = false;
      "untrap_sidebar_hide_button_your_videos" = true;
      "untrap_sidebar_hide_button_your_movies" = true;
      "untrap_sidebar_hide_button_watch_later" = false;
      "untrap_sidebar_hide_button_downloads" = true;
      "untrap_sidebar_hide_button_your_clips" = true;
      "untrap_sidebar_hide_library_button_show_more" = true;
      "untrap_sidebar_auto_expand_playlists" = true;
      "untrap_sidebar_hide_section_subscriptions" = true;
      "untrap_sidebar_hide_section_explore" = true;
      "untrap_sidebar_hide_section_more_from_youtube" = true;
      "untrap_sidebar_hide_section_helper_buttons" = true;
      "untrap_sidebar_hide_section_sign_in" = true;
      "untrap_sidebar_hide_section_footer" = true;
      "untrap_sidebar_hide_entire_sidebar" = true;
      "untrap_header_hide_search_bar" = false;
      "untrap_search_bar_hide_suggestions" = true;
      "untrap_search_bar_hide_previous_searches" = true;
      "untrap_header_hide_voice_search_button" = true;
      "untrap_header_hide_logo" = true;
      "untrap_header_hide_create_button" = true;
      "untrap_header_hide_upload_button" = true;
      "untrap_header_hide_notifications_bell" = true;
      "untrap_header_hide_button_avatar" = true;
      "untrap_header_hide_button_sign_in" = true;
      "untrap_header_hide_top_header" = true;
      "untrap_header_hide_notifications_counter" = true;
      "untrap_video_page_hide_related_videos" = true;
      "untrap_video_page_hide_suggestions_ads" = true;
      "untrap_video_page_hide_live_chat" = true;
      "untrap_video_page_fixed_sidebar" = false;
      "untrap_video_page_panels_max_height" = false;
      "untrap_video_player_hide_end_screen_suggestions" = true;
      "untrap_video_player_hide_end_screen_infos" = true;
      "untrap_video_player_hide_video_time" = false;
      "untrap_video_player_hide_video_watermark" = true;
      "untrap_video_page_auto_theater_mode" = true;
      "untrap_video_player_remove_corner_radius" = false;
      "untrap_video_page_grayscale_video_player" = false;
      "untrap_video_page_hide_video_title" = false;
      "untrap_video_page_hide_creator_avatar" = false;
      "untrap_video_page_Grayscale_creator_avatar" = false;
      "untrap_video_page_hide_creator_subscribers_counter" = false;
      "untrap_video_page_hide_metadata_row" = false;
      "untrap_video_page_auto_expand_description" = false;
      "untrap_video_page_minimal_description" = false;
      "untrap_video_player_hide_settings_button" = false;
      "untrap_video_player_hide_miniplayer_button" = true;
      "untrap_video_player_hide_theater_mode_button" = true;
      "untrap_video_player_hide_full_screen_button" = true;
      "untrap_video_page_hide_all_buttons_under_player" = false;
      "untrap_video_page_hide_button_subscribe" = false;
      "untrap_video_page_hide_video_likes_counter" = false;
      "untrap_video_page_hide_button_share" = false;
      "untrap_video_page_hide_button_clip" = false;
      "untrap_video_page_hide_button_save" = false;
      "untrap_video_page_hide_button_more" = true;
      "untrap_search_hide_ads_promoted_websites" = true;
      "untrap_search_hide_ads_promoted_videos" = true;
      "untrap_search_hide_ads_suggested_products" = true;
      "untrap_embed_hide_end_screen_suggestions" = true;
      "untrap_embed_hide_end_screen_infos" = true;
      "untrap_embed_player_hide_pause_recommenndations" = true;
      "untrap_global_enable" = true;
      "untrap_global_hide_all_ads" = true;
    };
  };
}
