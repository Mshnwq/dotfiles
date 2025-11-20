profile:
{
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.programs.firefox;
  inherit (pkgs.nur.repos.rycee) firefox-addons;
in
{
  home.file."${cfg.profilesPath}/${profile}/chrome".source = pkgs.shyfox;
  programs.firefox.profiles.${profile} = {
    userChrome = "";
    userContent = "";
    settings = {
      # Theme
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.download.autohideButton" = false;
      "browser.tabs.groups.smart.enabled" = false;
      ### ShyFox ###
      "sidebar.revamp" = false;
      "layout.css.has-selector.enabled" = true;
      "browser.urlbar.suggest.calculator" = false;
      "browser.urlbar.unitConversion.enabled" = false;
      "browser.urlbar.trimHttps" = false;
      "browser.urlbar.trimURLs" = false;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
      "widget.gtk.ignore-bogus-leave-notify" = 1;
      "svg.context-properties.content.enabled" = true;
    };

    extensions.packages = with firefox-addons; [
      darkreader
      pywalfox # remove shortcut Ctrl+Alt+D
      sidebery # remap Ctrl+E -> Ctrl+alt+E
      userchrome-toggle-extended # manually add shortcuts  1: Ctrl+E 2: Ctrl+Alt+S 3: Ctrl+Alt+H 4: Ctrl+Alt+C
    ];

    extensions.settings."userchrome-toggle-extended@n2ezr.ru".force = true;
    extensions.settings."userchrome-toggle-extended@n2ezr.ru".settings = {
      initialized = true;
      settingsVer = "2";
      allowMultiple = true;
      closePopup = true;
      useLastWindowToggles = false;
      keepToggles = false;
      toggles = [
        {
          name = "Style 1";
          enabled = true;
          prefix = "᠎";
          default_state = true;
        }
        {
          name = "Style 2";
          enabled = true;
          prefix = "​";
          default_state = true;
        }
        {
          name = "Style 3";
          enabled = true;
          prefix = "‌";
          default_state = false;
        }
        {
          name = "Style 4";
          enabled = true;
          prefix = "‍";
          default_state = false;
        }
        {
          name = "Style 5";
          enabled = false;
          prefix = "‎";
          default_state = false;
        }
        {
          name = "Style 6";
          enabled = false;
          prefix = "‏";
          default_state = false;
        }
      ];
    };

    extensions.settings."{3c078156-979c-498b-8990-85f7987dd929}".force = true;
    extensions.settings."{3c078156-979c-498b-8990-85f7987dd929}".settings = {
      "ver" = "5.4.0";
      "sidebar" = {
        "nav" = [
          "sp-pVOFdoIS_UVx"
          "F7y25cfnRQbQ"
          "XCK9s_Wv1otQ"
          "sp-q5-_0A3T8B8b"
        ];
        "panels" = {
          "F7y25cfnRQbQ" = {
            "type" = 2;
            "id" = "F7y25cfnRQbQ";
            "name" = "Tabs";
            "color" = "toolbar";
            "iconSVG" = "icon_tabs";
            "iconIMGSrc" = "";
            "iconIMG" = "";
            "lockedPanel" = false;
            "skipOnSwitching" = false;
            "noEmpty" = false;
            "newTabCtx" = "none";
            "dropTabCtx" = "none";
            "moveRules" = [ ];
            "moveExcludedTo" = -1;
            "bookmarksFolderId" = -1;
            "newTabBtns" = [ ];
            "srcPanelConfig" = null;
          };
          "XCK9s_Wv1otQ" = {
            "type" = 2;
            "id" = "XCK9s_Wv1otQ";
            "name" = "Code";
            "color" = "toolbar";
            "iconSVG" = "icon_code";
            "iconIMGSrc" = "";
            "iconIMG" = "";
            "lockedPanel" = false;
            "skipOnSwitching" = false;
            "noEmpty" = false;
            "newTabCtx" = "none";
            "dropTabCtx" = "none";
            "moveRules" = [ ];
            "moveExcludedTo" = -1;
            "bookmarksFolderId" = -1;
            "newTabBtns" = [ ];
            "srcPanelConfig" = null;
          };
        };
      };
      "settings" = {
        "nativeScrollbars" = false;
        "nativeScrollbarsThin" = false;
        "nativeScrollbarsLeft" = false;
        "selWinScreenshots" = false;
        "updateSidebarTitle" = false;
        "markWindow" = false;
        "markWindowPreface" = "sdbr ";
        "ctxMenuNative" = false;
        "ctxMenuRenderInact" = false;
        "ctxMenuRenderIcons" = true;
        "ctxMenuIgnoreContainers" = "";
        "navBarLayout" = "horizontal";
        "navBarInline" = false;
        "navBarSide" = "left";
        "hideAddBtn" = false;
        "hideSettingsBtn" = false;
        "navBtnCount" = true;
        "hideEmptyPanels" = false;
        "hideDiscardedTabPanels" = false;
        "navActTabsPanelLeftClickAction" = "none";
        "navActBookmarksPanelLeftClickAction" = "none";
        "navTabsPanelMidClickAction" = "discard";
        "navBookmarksPanelMidClickAction" = "none";
        "navSwitchPanelsWheel" = true;
        "subPanelRecentlyClosedBar" = true;
        "subPanelBookmarks" = true;
        "subPanelHistory" = true;
        "groupLayout" = "grid";
        "containersSortByName" = false;
        "skipEmptyPanels" = false;
        "dndTabAct" = false;
        "dndTabActDelay" = 750;
        "dndTabActMod" = "none";
        "dndExp" = "none";
        "dndExpDelay" = 750;
        "dndExpMod" = "none";
        "dndOutside" = "win";
        "dndActTabFromLink" = true;
        "dndActSearchTab" = true;
        "dndMoveTabs" = false;
        "dndMoveBookmarks" = false;
        "searchBarMode" = "dynamic";
        "searchPanelSwitch" = "any";
        "searchBookmarksShortcut" = "";
        "searchHistoryShortcut" = "";
        "warnOnMultiTabClose" = "any";
        "activateLastTabOnPanelSwitching" = true;
        "activateLastTabOnPanelSwitchingLoadedOnly" = true;
        "switchPanelAfterSwitchingTab" = "always";
        "tabRmBtn" = "hover";
        "activateAfterClosing" = "prev_act";
        "activateAfterClosingStayInPanel" = true;
        "activateAfterClosingGlobal" = false;
        "activateAfterClosingNoFolded" = true;
        "activateAfterClosingNoDiscarded" = true;
        "askNewBookmarkPlace" = true;
        "tabsRmUndoNote" = true;
        "tabsUnreadMark" = false;
        "tabsUpdateMark" = "pin";
        "tabsUpdateMarkFirst" = true;
        "tabsReloadLimit" = 5;
        "tabsReloadLimitNotif" = true;
        "showNewTabBtns" = true;
        "newTabBarPosition" = "after_tabs";
        "tabsPanelSwitchActMove" = true;
        "tabsPanelSwitchActMoveAuto" = true;
        "tabsUrlInTooltip" = "full";
        "newTabCtxReopen" = false;
        "tabWarmupOnHover" = true;
        "tabSwitchDelay" = 0;
        "moveNewTabPin" = "start";
        "moveNewTabParent" = "first_child";
        "moveNewTabParentActPanel" = false;
        "moveNewTab" = "end";
        "moveNewTabActivePin" = "start";
        "pinnedTabsPosition" = "top";
        "pinnedTabsList" = false;
        "pinnedAutoGroup" = false;
        "pinnedNoUnload" = false;
        "pinnedForcedDiscard" = false;
        "tabsTree" = true;
        "groupOnOpen" = true;
        "tabsTreeLimit" = "none";
        "autoFoldTabs" = false;
        "autoFoldTabsExcept" = "none";
        "autoExpandTabs" = false;
        "autoExpandTabsOnNew" = true;
        "rmChildTabs" = "folded";
        "tabsLvlDots" = false;
        "discardFolded" = true;
        "discardFoldedDelay" = 30;
        "discardFoldedDelayUnit" = "sec";
        "tabsTreeBookmarks" = true;
        "treeRmOutdent" = "branch";
        "autoGroupOnClose" = false;
        "autoGroupOnClose0Lvl" = false;
        "autoGroupOnCloseMouseOnly" = false;
        "ignoreFoldedParent" = false;
        "showNewGroupConf" = true;
        "sortGroupsFirst" = true;
        "colorizeTabs" = true;
        "colorizeTabsSrc" = "container";
        "colorizeTabsBranches" = false;
        "colorizeTabsBranchesSrc" = "url";
        "inheritCustomColor" = false;
        "previewTabs" = false;
        "previewTabsMode" = "p";
        "previewTabsPageModeFallback" = "i";
        "previewTabsInlineHeight" = 70;
        "previewTabsPopupWidth" = 280;
        "previewTabsSide" = "right";
        "previewTabsDelay" = 500;
        "previewTabsFollowMouse" = true;
        "previewTabsWinOffsetY" = 36;
        "previewTabsWinOffsetX" = 6;
        "previewTabsInPageOffsetY" = 0;
        "previewTabsInPageOffsetX" = 0;
        "previewTabsCropRight" = 0;
        "hideInact" = false;
        "hideFoldedTabs" = false;
        "hideFoldedParent" = "none";
        "nativeHighlight" = false;
        "warnOnMultiBookmarkDelete" = "any";
        "autoCloseBookmarks" = false;
        "autoRemoveOther" = false;
        "highlightOpenBookmarks" = true;
        "activateOpenBookmarkTab" = true;
        "showBookmarkLen" = true;
        "bookmarksRmUndoNote" = true;
        "loadBookmarksOnDemand" = true;
        "pinOpenedBookmarksFolder" = true;
        "oldBookmarksAfterSave" = "ask";
        "loadHistoryOnDemand" = true;
        "fontSize" = "m";
        "animations" = true;
        "animationSpeed" = "fast";
        "theme" = "proton";
        "density" = "default";
        "colorScheme" = "ff";
        "sidebarCSS" = false;
        "groupCSS" = false;
        "snapNotify" = true;
        "snapExcludePrivate" = true;
        "snapInterval" = 1;
        "snapIntervalUnit" = "day";
        "snapLimit" = 3;
        "snapLimitUnit" = "day";
        "snapAutoExport" = false;
        "snapAutoExportType" = "json";
        "snapAutoExportPath" = "Sidebery/snapshot-%Y.%M.%D-%h.%m.%s";
        "snapMdFullTree" = true;
        "hScrollAction" = "switch_panels";
        "onePanelSwitchPerScroll" = true;
        "wheelAccumulationX" = true;
        "wheelAccumulationY" = true;
        "navSwitchPanelsDelay" = 250;
        "scrollThroughTabs" = "none";
        "scrollThroughVisibleTabs" = true;
        "scrollThroughTabsSkipDiscarded" = true;
        "scrollThroughTabsExceptOverflow" = true;
        "scrollThroughTabsCyclic" = true;
        "scrollThroughTabsScrollArea" = 0;
        "autoMenuMultiSel" = true;
        "multipleMiddleClose" = true;
        "longClickDelay" = 500;
        "wheelThreshold" = false;
        "wheelThresholdX" = 10;
        "wheelThresholdY" = 60;
        "tabDoubleClick" = "edit_title";
        "tabsSecondClickActPrev" = false;
        "tabsSecondClickActPrevPanelOnly" = false;
        "shiftSelAct" = false;
        "activateOnMouseUp" = true;
        "tabLongLeftClick" = "reload";
        "tabLongRightClick" = "reload";
        "tabMiddleClick" = "close";
        "tabMiddleClickCtrl" = "discard";
        "tabMiddleClickShift" = "none";
        "tabCloseMiddleClick" = "discard";
        "tabsPanelLeftClickAction" = "none";
        "tabsPanelDoubleClickAction" = "undo";
        "tabsPanelRightClickAction" = "menu";
        "tabsPanelMiddleClickAction" = "tab";
        "newTabMiddleClickAction" = "new_child";
        "bookmarksLeftClickAction" = "open_in_new";
        "bookmarksLeftClickActivate" = true;
        "bookmarksLeftClickPos" = "default";
        "bookmarksMidClickAction" = "open_in_new";
        "bookmarksMidClickActivate" = false;
        "bookmarksMidClickRemove" = false;
        "bookmarksMidClickPos" = "default";
        "historyLeftClickAction" = "open_in_new";
        "historyLeftClickActivate" = true;
        "historyLeftClickPos" = "default";
        "historyMidClickAction" = "open_in_new";
        "historyMidClickActivate" = false;
        "historyMidClickPos" = "default";
        "syncName" = "";
        "syncSaveSettings" = true;
        "syncSaveCtxMenu" = true;
        "syncSaveStyles" = true;
        "syncSaveKeybindings" = true;
        "selectActiveTabFirst" = true;
      };
    };
  };
}
