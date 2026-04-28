# programs/obsidian/plugins.nix
{
  pkgs,
  ...
}:
{
  advancedUri =
    let
      version = "1.46.1";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/main.js";
        hash = "sha256:d10300fb667eb9e93417427fc3ea010f46db020885d29c5decc78735c14ab162";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/manifest.json";
        hash = "sha256:fa12d5488bf1d61b829272b15de72fea27d1f2d6ac854f97ec97a6cc2784c2f1";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-advanced-uri";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      settings = {
        "openFileOnWrite" = true;
        "openDailyInNewPane" = false;
        "openFileOnWriteInNewPane" = false;
        "openFileWithoutWriteInNewPane" = true;
        "idField" = "id";
        "useUID" = false;
        "addFilepathWhenUsingUID" = false;
        "allowEval" = false;
        "includeVaultName" = true;
        "vaultParam" = "name";
        "linkFormats" = [
          {
            "name" = "Markdown";
            "format" = "[{{name}}]({{uri}})";
          }
        ];
      };
    };

  # https://excalidraw-obsidian.online/
  excalidraw =
    let
      version = "2.22.0";
      # https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/tag/2.22.0
      mainJs = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/main.js";
        hash = "sha256:8f7d5dc538228020805a255db9615ba2fdb82a9c0e6081f1b37ee7c2750ab37e";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/manifest.json";
        hash = "sha256:e4788bd00c9890f62c939d51676ed2eaa392748a738f292d47721df6fe100553";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/styles.css";
        hash = "sha256:5581af67d9a8cc133774420c7974d03a7cbcb5ebce209d6e8e0a53e00bde3f00";
      };
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "obsidian-excalidraw-plugin";
      version = "v${version}";
      dontUnpack = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp ${mainJs} $out/main.js
        cp ${manifestJson} $out/manifest.json
        cp ${stylesCss} $out/styles.css
        runHook postInstall
      '';
    };

  nodeFactor =
    let
      version = "3.0.0";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/CalfMoon/node-factor/releases/download/${version}/main.js";
        hash = "sha256:d9cacb6d0bb2e0a99a129412e6924e2c7e9fc4bea4351947529863270d8fbb41";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/CalfMoon/node-factor/releases/download/${version}/manifest.json";
        hash = "sha256:6b95c3e67c2c72af9a3c8e46b9cceb96158b1ac2932ca6481151f3b9f271a211";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "node-factor";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      # still figuring it out
      settings = {
        "fwdMultiplier" = 2;
        "fwdTree" = false;
        "bwdMultiplier" = 4;
        "lettersPerWt" = 0;
        "manual" = [ ];
      };
    };

  dataView =
    let
      version = "0.5.70";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/main.js";
        hash = "sha256-a7HPcBCvrYMOc1dfyg4r+9MnnFYuPZ0k8tL0UWHrfQA=";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/manifest.json";
        hash = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/styles.css";
        hash = "sha256-MwbdkDLgD5ibpyM6N/0lW8TT9DQM7mYXYulS8/aqHek=";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-dataview";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${manifestJson} $out/manifest.json
          cp ${stylesCss} $out/styles.css
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      settings = {
        "renderNullAs" = "\\-";
        "taskCompletionTracking" = false;
        "taskCompletionUseEmojiShorthand" = false;
        "taskCompletionText" = "completion";
        "taskCompletionDateFormat" = "yyyy-MM-dd";
        "recursiveSubTaskCompletion" = false;
        "warnOnEmptyResult" = true;
        "refreshEnabled" = true;
        "refreshInterval" = 2500;
        "defaultDateFormat" = "MMMM dd, yyyy";
        "defaultDateTimeFormat" = "h:mm a - MMMM dd, yyyy";
        "maxRecursiveRenderDepth" = 4;
        "tableIdColumnName" = "File";
        "tableGroupColumnName" = "Group";
        "showResultCount" = true;
        "allowHtml" = true;
        "inlineQueryPrefix" = "=";
        "inlineJsQueryPrefix" = "$=";
        "inlineQueriesInCodeblocks" = true;
        "enableInlineDataview" = true;
        "enableDataviewJs" = true;
        "enableInlineDataviewJs" = true;
        "prettyRenderInlineFields" = true;
        "prettyRenderInlineFieldsInLivePreview" = true;
        "dataviewJsKeyword" = "dataviewjs";
      };
    };
  #
  # # https://github.com/johansan/notebook-navigator#8-custom-hotkeys
  # notebookNavigator =
  #   let
  #     version = "2.6.3";
  #     mainJs = pkgs.fetchurl {
  #       url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/main.js";
  #       hash = "sha256:efba56b71c3f7f9ede5a0fca871fcdb3ee349ed5911849822049780a36b0989a";
  #     };
  #     manifestJson = pkgs.fetchurl {
  #       url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/manifest.json";
  #       hash = "sha256:5d2cfb1aed3978f7647eecab037316f38420a7db1e745d6c5012d039edbfbc2b";
  #     };
  #     stylesCss = pkgs.fetchurl {
  #       url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/styles.css";
  #       hash = "sha256:cfd3528c84126ec694e6115d08ddd6e5d57c5b47c360c9d15c4ddcda13ada7bd";
  #     };
  #     pkg = pkgs.stdenvNoCC.mkDerivation {
  #       pname = "notebook-navigator";
  #       version = "${version}";
  #       dontUnpack = true;
  #       installPhase = ''
  #         runHook preInstall
  #         mkdir -p $out
  #         cp ${mainJs} $out/main.js
  #         cp ${manifestJson} $out/manifest.json
  #         cp ${stylesCss} $out/styles.css
  #         runHook postInstall
  #       '';
  #     };
  #   in
  #   {
  #     inherit pkg;
  #     # settings = {
  #     #   "vaultProfiles": [
  #     #     {
  #     #       "id": "default",
  #     #       "name": "Default",
  #     #       "fileVisibility": "documents",
  #     #       "propertyKeys": [],
  #     #       "hiddenFolders": [
  #     #         "_*"
  #     #       ],
  #     #       "hiddenTags": [],
  #     #       "hiddenFileNames": [],
  #     #       "hiddenFileTags": [],
  #     #       "hiddenFileProperties": [],
  #     #       "navigationBanner": null,
  #     #       "periodicNotesFolder": "",
  #     #       "shortcuts": [
  #     #         {
  #     #           "type": "note",
  #     #           "path": "obsidian-nvim-guide.md"
  #     #         }
  #     #       ],
  #     #       "navRainbow": {
  #     #         "mode": "none",
  #     #         "balanceHueLuminance": true,
  #     #         "separateThemeColors": false,
  #     #         "shortcuts": {
  #     #           "enabled": false,
  #     #           "firstColor": "#ef4444",
  #     #           "lastColor": "#8b5cf6",
  #     #           "darkFirstColor": "#ef4444",
  #     #           "darkLastColor": "#8b5cf6",
  #     #           "transitionStyle": "rgb"
  #     #         },
  #     #         "recent": {
  #     #           "enabled": false,
  #     #           "firstColor": "#ef4444",
  #     #           "lastColor": "#8b5cf6",
  #     #           "darkFirstColor": "#ef4444",
  #     #           "darkLastColor": "#8b5cf6",
  #     #           "transitionStyle": "rgb"
  #     #         },
  #     #         "folders": {
  #     #           "enabled": true,
  #     #           "firstColor": "#ef4444",
  #     #           "lastColor": "#8b5cf6",
  #     #           "darkFirstColor": "#fb7185",
  #     #           "darkLastColor": "#c084fc",
  #     #           "transitionStyle": "hue",
  #     #           "scope": "root"
  #     #         },
  #     #         "tags": {
  #     #           "enabled": false,
  #     #           "firstColor": "#ef4444",
  #     #           "lastColor": "#8b5cf6",
  #     #           "darkFirstColor": "#fb7185",
  #     #           "darkLastColor": "#c084fc",
  #     #           "transitionStyle": "hue",
  #     #           "scope": "root"
  #     #         },
  #     #         "properties": {
  #     #           "enabled": false,
  #     #           "firstColor": "#ef4444",
  #     #           "lastColor": "#8b5cf6",
  #     #           "darkFirstColor": "#fb7185",
  #     #           "darkLastColor": "#c084fc",
  #     #           "transitionStyle": "hue",
  #     #           "scope": "root"
  #     #         }
  #     #       }
  #     #     }
  #     #   ],
  #     #   "vaultProfile": "default",
  #     #   "vaultTitle": "header",
  #     #   "syncModes": {
  #     #     "vaultProfile": "synced",
  #     #     "homepage": "synced",
  #     #     "folderSortOrder": "synced",
  #     #     "tagSortOrder": "synced",
  #     #     "propertySortOrder": "synced",
  #     #     "includeDescendantNotes": "synced",
  #     #     "useFloatingToolbars": "synced",
  #     #     "dualPane": "synced",
  #     #     "dualPaneOrientation": "synced",
  #     #     "paneTransitionDuration": "synced",
  #     #     "toolbarVisibility": "synced",
  #     #     "pinNavigationBanner": "synced",
  #     #     "navIndent": "synced",
  #     #     "navItemHeight": "synced",
  #     #     "navItemHeightScaleText": "synced",
  #     #     "calendarPlacement": "synced",
  #     #     "calendarLeftPlacement": "synced",
  #     #     "calendarWeeksToShow": "synced",
  #     #     "compactItemHeight": "synced",
  #     #     "compactItemHeightScaleText": "synced",
  #     #     "featureImageSize": "synced",
  #     #     "featureImagePixelSize": "synced",
  #     #     "uiScale": "synced"
  #     #   },
  #     #   "createNewNotesInNewTab": false,
  #     #   "autoRevealActiveFile": true,
  #     #   "autoRevealShortestPath": true,
  #     #   "autoRevealIgnoreRightSidebar": true,
  #     #   "autoRevealIgnoreOtherWindows": true,
  #     #   "paneTransitionDuration": 150,
  #     #   "multiSelectModifier": "cmdCtrl",
  #     #   "enterToOpenFiles": true,
  #     #   "shiftEnterOpenContext": "split",
  #     #   "cmdCtrlEnterOpenContext": "tab",
  #     #   "mouseBackForwardAction": "history",
  #     #   "startView": "navigation",
  #     #   "showInfoButtons": true,
  #     #   "homepage": {
  #     #     "source": "none",
  #     #     "file": null,
  #     #     "createMissingPeriodicNote": true
  #     #   },
  #     #   "dualPane": true,
  #     #   "dualPaneOrientation": "horizontal",
  #     #   "showTooltips": false,
  #     #   "showTooltipPath": true,
  #     #   "desktopBackground": "separate",
  #     #   "desktopScale": 1.1,
  #     #   "mobileScale": 1,
  #     #   "useFloatingToolbars": true,
  #     #   "toolbarVisibility": {
  #     #     "navigation": {
  #     #       "toggleDualPane": false,
  #     #       "expandCollapse": false,
  #     #       "calendar": false,
  #     #       "hiddenItems": false,
  #     #       "rootReorder": false,
  #     #       "newFolder": false
  #     #     },
  #     #     "list": {
  #     #       "back": true,
  #     #       "search": false,
  #     #       "descendants": true,
  #     #       "sort": false,
  #     #       "appearance": true,
  #     #       "newNote": false
  #     #     }
  #     #   },
  #     #   "interfaceIcons": {},
  #     #   "colorIconOnly": false,
  #     #   "dateFormat": "MMM D, YYYY",
  #     #   "timeFormat": "h:mm a",
  #     #   "calendarTemplateFolder": "",
  #     #   "confirmBeforeDelete": true,
  #     #   "deleteAttachments": "ask",
  #     #   "moveFileConflicts": "ask",
  #     #   "externalIconProviders": {},
  #     #   "checkForUpdatesOnStart": true,
  #     #   "pinNavigationBanner": false,
  #     #   "showNoteCount": true,
  #     #   "separateNoteCounts": false,
  #     #   "showIndentGuides": true,
  #     #   "rootLevelSpacing": 0,
  #     #   "navIndent": 10,
  #     #   "navItemHeight": 28,
  #     #   "navItemHeightScaleText": false,
  #     #   "collapseBehavior": "all",
  #     #   "smartCollapse": true,
  #     #   "autoSelectFirstFileOnFocusChange": false,
  #     #   "autoExpandNavItems": true,
  #     #   "springLoadedFolders": true,
  #     #   "springLoadedFoldersInitialDelay": 0.5,
  #     #   "springLoadedFoldersSubsequentDelay": 0.5,
  #     #   "showSectionIcons": true,
  #     #   "showShortcuts": true,
  #     #   "shortcutBadgeDisplay": "index",
  #     #   "skipAutoScroll": false,
  #     #   "showRecentNotes": true,
  #     #   "hideRecentNotes": "none",
  #     #   "pinRecentNotesWithShortcuts": false,
  #     #   "recentNotesCount": 5,
  #     #   "showFolderIcons": true,
  #     #   "showRootFolder": true,
  #     #   "inheritFolderColors": true,
  #     #   "folderSortOrder": "alpha-asc",
  #     #   "enableFolderNotes": false,
  #     #   "folderNoteType": "markdown",
  #     #   "folderNoteName": "",
  #     #   "folderNoteNamePattern": "",
  #     #   "folderNoteTemplate": null,
  #     #   "enableFolderNoteLinks": true,
  #     #   "hideFolderNoteInList": true,
  #     #   "pinCreatedFolderNote": false,
  #     #   "openFolderNotesInNewTab": false,
  #     #   "showTags": true,
  #     #   "showTagIcons": true,
  #     #   "showAllTagsFolder": true,
  #     #   "showUntagged": true,
  #     #   "scopeTagsToCurrentContext": false,
  #     #   "tagSortOrder": "alpha-asc",
  #     #   "inheritTagColors": true,
  #     #   "keepEmptyTagsProperty": false,
  #     #   "showProperties": true,
  #     #   "showPropertyIcons": true,
  #     #   "inheritPropertyColors": true,
  #     #   "propertySortOrder": "alpha-asc",
  #     #   "showAllPropertiesFolder": true,
  #     #   "scopePropertiesToCurrentContext": false,
  #     #   "defaultListMode": "standard",
  #     #   "includeDescendantNotes": true,
  #     #   "defaultFolderSort": "modified-desc",
  #     #   "propertySortKey": "",
  #     #   "propertySortSecondary": "title",
  #     #   "revealFileOnListChanges": true,
  #     #   "listPaneTitle": "header",
  #     #   "noteGrouping": "date",
  #     #   "showSelectedNavigationPills": false,
  #     #   "filterPinnedByFolder": false,
  #     #   "showPinnedGroupHeader": true,
  #     #   "showPinnedIcon": true,
  #     #   "optimizeNoteHeight": true,
  #     #   "compactItemHeight": 28,
  #     #   "compactItemHeightScaleText": true,
  #     #   "showQuickActions": false,
  #     #   "quickActionRevealInFolder": false,
  #     #   "quickActionAddTag": true,
  #     #   "quickActionAddToShortcuts": false,
  #     #   "quickActionPinNote": false,
  #     #   "quickActionOpenInNewTab": false,
  #     #   "useFrontmatterMetadata": false,
  #     #   "frontmatterIconField": "icon",
  #     #   "frontmatterColorField": "color",
  #     #   "frontmatterBackgroundField": "background",
  #     #   "frontmatterNameField": "",
  #     #   "frontmatterCreatedField": "",
  #     #   "frontmatterModifiedField": "",
  #     #   "frontmatterDateFormat": "",
  #     #   "showFileIconUnfinishedTask": false,
  #     #   "showFileBackgroundUnfinishedTask": false,
  #     #   "unfinishedTaskBackgroundColor": "#ef000050",
  #     #   "showFileIcons": false,
  #     #   "showFilenameMatchIcons": false,
  #     #   "fileNameIconMap": {},
  #     #   "showCategoryIcons": false,
  #     #   "fileTypeIconMap": {},
  #     #   "fileNameRows": 1,
  #     #   "showFilePreview": true,
  #     #   "skipHeadingsInPreview": true,
  #     #   "skipCodeBlocksInPreview": true,
  #     #   "stripHtmlInPreview": true,
  #     #   "stripLatexInPreview": true,
  #     #   "previewRows": 1,
  #     #   "previewProperties": [],
  #     #   "previewPropertiesFallback": true,
  #     #   "showFeatureImage": false,
  #     #   "featureImageProperties": [],
  #     #   "featureImageExcludeProperties": [],
  #     #   "featureImageSize": "64",
  #     #   "featureImagePixelSize": "256",
  #     #   "forceSquareFeatureImage": true,
  #     #   "downloadExternalFeatureImages": true,
  #     #   "showFileTags": true,
  #     #   "colorFileTags": true,
  #     #   "prioritizeColoredFileTags": true,
  #     #   "showFileTagAncestors": false,
  #     #   "showFileTagsInCompactMode": false,
  #     #   "showFileProperties": true,
  #     #   "colorFileProperties": true,
  #     #   "prioritizeColoredFileProperties": true,
  #     #   "showFilePropertiesInCompactMode": false,
  #     #   "showPropertiesOnSeparateRows": false,
  #     #   "enablePropertyInternalLinks": true,
  #     #   "enablePropertyExternalLinks": true,
  #     #   "notePropertyType": "none",
  #     #   "showFileDate": false,
  #     #   "alphabeticalDateMode": "modified",
  #     #   "showParentFolder": false,
  #     #   "parentFolderClickRevealsFile": false,
  #     #   "showParentFolderColor": false,
  #     #   "showParentFolderIcon": false,
  #     #   "calendarEnabled": true,
  #     #   "calendarPlacement": "right-sidebar",
  #     #   "calendarConfirmBeforeCreate": true,
  #     #   "calendarLocale": "system-default",
  #     #   "calendarWeekendDays": "fri-sat",
  #     #   "calendarMonthHeadingFormat": "full",
  #     #   "calendarHighlightToday": true,
  #     #   "calendarShowFeatureImage": false,
  #     #   "calendarMonthHighlights": {},
  #     #   "calendarShowWeekNumber": false,
  #     #   "calendarShowQuarter": false,
  #     #   "calendarShowYearCalendar": false,
  #     #   "calendarLeftPlacement": "below",
  #     #   "calendarWeeksToShow": 1,
  #     #   "calendarIntegrationMode": "daily-notes",
  #     #   "calendarCustomFilePattern": "YYYY/YYYYMMDD",
  #     #   "calendarCustomWeekPattern": "gggg/[W]ww",
  #     #   "calendarCustomMonthPattern": "YYYY/YYYYMM",
  #     #   "calendarCustomQuarterPattern": "YYYY/[Q]Q",
  #     #   "calendarCustomYearPattern": "YYYY",
  #     #   "calendarCustomFileTemplate": null,
  #     #   "calendarCustomWeekTemplate": null,
  #     #   "calendarCustomMonthTemplate": null,
  #     #   "calendarCustomQuarterTemplate": null,
  #     #   "calendarCustomYearTemplate": null,
  #     #   "keyboardShortcuts": {
  #     #     "pane:move-up": [
  #     #       {
  #     #         "key": "ArrowUp",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:move-down": [
  #     #       {
  #     #         "key": "ArrowDown",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:page-up": [
  #     #       {
  #     #         "key": "PageUp",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:page-down": [
  #     #       {
  #     #         "key": "PageDown",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:home": [
  #     #       {
  #     #         "key": "Home",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:end": [
  #     #       {
  #     #         "key": "End",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "navigation:collapse-or-parent": [
  #     #       {
  #     #         "key": "ArrowLeft",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "navigation:expand-or-focus-list": [
  #     #       {
  #     #         "key": "ArrowRight",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "navigation:focus-list": [
  #     #       {
  #     #         "key": "Tab",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "pane:delete-selected": [
  #     #       {
  #     #         "key": "Delete",
  #     #         "modifiers": []
  #     #       },
  #     #       {
  #     #         "key": "Backspace",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "list:focus-navigation": [
  #     #       {
  #     #         "key": "ArrowLeft",
  #     #         "modifiers": []
  #     #       },
  #     #       {
  #     #         "key": "Tab",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "list:focus-editor": [
  #     #       {
  #     #         "key": "ArrowRight",
  #     #         "modifiers": []
  #     #       },
  #     #       {
  #     #         "key": "Tab",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "list:select-all": [
  #     #       {
  #     #         "key": "A",
  #     #         "modifiers": [
  #     #           "Mod"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "list:extend-selection-up": [
  #     #       {
  #     #         "key": "ArrowUp",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "list:extend-selection-down": [
  #     #       {
  #     #         "key": "ArrowDown",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "list:range-to-start": [
  #     #       {
  #     #         "key": "Home",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "list:range-to-end": [
  #     #       {
  #     #         "key": "End",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "search:focus-list": [
  #     #       {
  #     #         "key": "Tab",
  #     #         "modifiers": []
  #     #       },
  #     #       {
  #     #         "key": "Enter",
  #     #         "modifiers": []
  #     #       }
  #     #     ],
  #     #     "search:focus-navigation": [
  #     #       {
  #     #         "key": "Tab",
  #     #         "modifiers": [
  #     #           "Shift"
  #     #         ]
  #     #       }
  #     #     ],
  #     #     "search:close": [
  #     #       {
  #     #         "key": "Escape",
  #     #         "modifiers": []
  #     #       }
  #     #     ]
  #     #   },
  #     #   "customVaultName": "",
  #     #   "pinnedNotes": {},
  #     #   "fileIcons": {},
  #     #   "fileColors": {},
  #     #   "fileBackgroundColors": {},
  #     #   "folderIcons": {},
  #     #   "folderColors": {},
  #     #   "folderBackgroundColors": {},
  #     #   "folderSortOverrides": {},
  #     #   "folderTreeSortOverrides": {},
  #     #   "folderAppearances": {
  #     #     "3_Indexes/Dates": {
  #     #       "previewRows": 1
  #     #     }
  #     #   },
  #     #   "tagIcons": {},
  #     #   "tagColors": {},
  #     #   "tagBackgroundColors": {},
  #     #   "tagSortOverrides": {},
  #     #   "tagTreeSortOverrides": {},
  #     #   "tagAppearances": {},
  #     #   "propertyIcons": {},
  #     #   "propertyColors": {},
  #     #   "propertyBackgroundColors": {},
  #     #   "propertySortOverrides": {},
  #     #   "propertyTreeSortOverrides": {},
  #     #   "propertyAppearances": {},
  #     #   "virtualFolderColors": {},
  #     #   "virtualFolderBackgroundColors": {},
  #     #   "navigationSeparators": {},
  #     #   "userColors": [
  #     #     "#ffffff",
  #     #     "#d9d9d9",
  #     #     "#a6a6a6",
  #     #     "#737373",
  #     #     "#000000",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040",
  #     #     "#404040"
  #     #   ],
  #     #   "lastShownVersion": "2.6.2",
  #     #   "rootFolderOrder": [],
  #     #   "rootTagOrder": [],
  #     #   "rootPropertyOrder": []
  #     # };
  #   };

  calendar =
    let
      version = "1.5.10";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/liamcain/obsidian-calendar-plugin/releases/download/${version}/main.js";
        hash = "sha256-f7M56c+f2+WoAforirhbNmtbN3f70ZPLyHKLwncR0SU=";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/liamcain/obsidian-calendar-plugin/releases/download/${version}/manifest.json";
        hash = "sha256-8+lYEzhkhRK6oS1bRYSQ9/02eRj3vba9hhcc5Xvn0Is=";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-calendar-plugin";
        version = "${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      settings = {
        "shouldConfirmBeforeCreate" = true;
        "weekStart" = "locale";
        "wordsPerDot" = 250;
        "showWeeklyNote" = false;
        "weeklyNoteFormat" = "";
        "weeklyNoteTemplate" = "";
        "weeklyNoteFolder" = "";
        "localeOverride" = "system-default";
      };
    };
}
