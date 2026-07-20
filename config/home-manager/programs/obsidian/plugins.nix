# programs/obsidian/plugins.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Fetches manifest.json/main.js/(optional) styles.css from a GitHub release
  # and assembles them into the directory layout Obsidian expects for a
  # community plugin. `hashes.styles` presence decides whether styles.css is
  # fetched/copied at all; `versionPrefix` covers the "v1.2.3" vs "1.2.3" tag
  # naming inconsistency across plugin authors.
  mkPlugin =
    {
      repo, # "owner/repo" on GitHub
      version,
      pname,
      hashes, # { manifest, main, styles ? null }
      versionPrefix ? "",
    }:
    let
      fetchAsset =
        name: hash:
        pkgs.fetchurl {
          url = "https://github.com/${repo}/releases/download/${version}/${name}";
          inherit hash;
        };
      manifestJson = fetchAsset "manifest.json" hashes.manifest;
      mainJs = fetchAsset "main.js" hashes.main;
      hasStyles = hashes ? styles;
      stylesCss = if hasStyles then fetchAsset "styles.css" hashes.styles else null;
    in
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname;
      version = "${versionPrefix}${version}";
      dontUnpack = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp ${mainJs} $out/main.js
        cp ${manifestJson} $out/manifest.json
        ${lib.optionalString hasStyles "cp ${stylesCss} $out/styles.css"}
        runHook postInstall
      '';
    };
in
{
  advancedUri = {
    pkg = mkPlugin {
      repo = "Vinzent03/obsidian-advanced-uri";
      version = "1.46.1";
      pname = "obsidian-advanced-uri";
      versionPrefix = "v";
      hashes = {
        manifest = "sha256:fa12d5488bf1d61b829272b15de72fea27d1f2d6ac854f97ec97a6cc2784c2f1";
        main = "sha256:d10300fb667eb9e93417427fc3ea010f46db020885d29c5decc78735c14ab162";
      };
    };
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
  excalidraw = {
    pkg = mkPlugin {
      repo = "zsviczian/obsidian-excalidraw-plugin";
      version = "2.22.0"; # https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/tag/2.22.0
      pname = "obsidian-excalidraw-plugin";
      versionPrefix = "v";
      hashes = {
        manifest = "sha256:e4788bd00c9890f62c939d51676ed2eaa392748a738f292d47721df6fe100553";
        main = "sha256:8f7d5dc538228020805a255db9615ba2fdb82a9c0e6081f1b37ee7c2750ab37e";
        styles = "sha256:5581af67d9a8cc133774420c7974d03a7cbcb5ebce209d6e8e0a53e00bde3f00";
      };
    };
  };

  nodeFactor = {
    pkg = mkPlugin {
      repo = "CalfMoon/node-factor";
      version = "3.0.0";
      pname = "node-factor";
      versionPrefix = "v";
      hashes = {
        manifest = "sha256:6b95c3e67c2c72af9a3c8e46b9cceb96158b1ac2932ca6481151f3b9f271a211";
        main = "sha256:d9cacb6d0bb2e0a99a129412e6924e2c7e9fc4bea4351947529863270d8fbb41";
      };
    };
    # still figuring it out
    settings = {
      "fwdMultiplier" = 2;
      "fwdTree" = false;
      "bwdMultiplier" = 4;
      "lettersPerWt" = 0;
      "manual" = [ ];
    };
  };

  dataView = {
    pkg = mkPlugin {
      repo = "blacksmithgu/obsidian-dataview";
      version = "0.5.70";
      pname = "obsidian-dataview";
      versionPrefix = "v";
      hashes = {
        manifest = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
        main = "sha256-a7HPcBCvrYMOc1dfyg4r+9MnnFYuPZ0k8tL0UWHrfQA=";
        styles = "sha256-MwbdkDLgD5ibpyM6N/0lW8TT9DQM7mYXYulS8/aqHek=";
      };
    };
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

  # https://github.com/johansan/notebook-navigator#8-custom-hotkeys
  notebookNavigator = {
    pkg = mkPlugin {
      repo = "johansan/notebook-navigator";
      version = "2.6.3";
      pname = "notebook-navigator";
      hashes = {
        manifest = "sha256:5d2cfb1aed3978f7647eecab037316f38420a7db1e745d6c5012d039edbfbc2b";
        main = "sha256:efba56b71c3f7f9ede5a0fca871fcdb3ee349ed5911849822049780a36b0989a";
        styles = "sha256:cfd3528c84126ec694e6115d08ddd6e5d57c5b47c360c9d15c4ddcda13ada7bd";
      };
    };
    # ensure it matches in sops.secrets.notebook-navigator.path
    settings = builtins.fromJSON (
      builtins.readFile "${config.xdg.configHome}/obsidian-notebook-navigator.json"
    );
  };

  styleSettings = {
    pkg = mkPlugin {
      repo = "obsidian-community/obsidian-style-settings";
      version = "1.0.9";
      pname = "obsidian-style-settings";
      hashes = {
        manifest = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g=";
        main = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
        styles = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
      };
    };
  };

  # https://aitorllamas.com/obsidian-lovely-bases/
  lovelyBases = {
    pkg = mkPlugin {
      repo = "aitorllj93/obsidian-lovely-bases";
      version = "0.2.2";
      pname = "obsidian-lovely-bases";
      versionPrefix = "v";
      hashes = {
        manifest = "sha256:1c39e53a9e01f2c4fa8da250b592b8569de24ccec47bfcc6964b361fff1e4a2d";
        main = "sha256:f512b3279ad1344d90956380a287e546bd22cdd2a7c386e26a7dd53805b578ec";
        styles = "sha256:b5075812a991be0816f773c37f049943b08296a08ffadf43afc090b4d9f6dcdb";
      };
    };
  };

  omnisearch = {
    pkg = mkPlugin {
      repo = "scambier/obsidian-omnisearch";
      version = "1.28.2";
      pname = "obsidian-omnisearch";
      hashes = {
        manifest = "sha256:9f741ed48b1017efc73e67fc7cd113e910cb35daf3e6b996e8ba0215c5546dae";
        main = "sha256:787e80d61a7f482ae4a69940c8e34f972f9eb264c5c69dd83c50ddde9458a958";
        styles = "sha256:b70b786c51a899e376fb936954f655908709fe3cb746d98f1ba1f5171852ae2b";
      };
    };
    settings = {
      "useCache" = true;
      "hideExcluded" = true;
      "recencyBoost" = "0";
      "downrankedFoldersFilters" = [ ];
      "ignoreDiacritics" = true;
      "ignoreArabicDiacritics" = false;
      "indexedFileTypes" = [ ];
      "displayTitle" = "";
      "PDFIndexing" = false;
      "officeIndexing" = false;
      "imagesIndexing" = false;
      "aiImageIndexing" = false;
      "unsupportedFilesIndexing" = "default";
      "splitCamelCase" = false;
      "openInNewPane" = false;
      "vimLikeNavigationShortcut" = false;
      "ribbonIcon" = true;
      "showExcerpt" = true;
      "maxEmbeds" = 5;
      "renderLineReturnInExcerpts" = true;
      "showCreateButton" = false;
      "highlight" = true;
      "showPreviousQueryResults" = true;
      "simpleSearch" = false;
      "tokenizeUrls" = false;
      "fuzziness" = "1";
      "weightBasename" = 10;
      "weightDirectory" = 7;
      "weightH1" = 6;
      "weightH2" = 5;
      "weightH3" = 4;
      "weightUnmarkedTags" = 2;
      "weightCustomProperties" = [ ];
      "httpApiEnabled" = false;
      "httpApiPort" = "51361";
      "httpApiNotice" = true;
      "welcomeMessage" = "1.21.0";
      "verboseLogging" = false;
      "DANGER_httpHost" = null;
      "DANGER_forceSaveCache" = false;
    };
  };

  calendar = {
    pkg = mkPlugin {
      repo = "liamcain/obsidian-calendar-plugin";
      version = "1.5.10";
      pname = "obsidian-calendar-plugin";
      hashes = {
        manifest = "sha256-8+lYEzhkhRK6oS1bRYSQ9/02eRj3vba9hhcc5Xvn0Is=";
        main = "sha256-f7M56c+f2+WoAforirhbNmtbN3f70ZPLyHKLwncR0SU=";
      };
    };
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

  metaBind = {
    pkg = mkPlugin {
      repo = "mProjectsCode/obsidian-meta-bind-plugin";
      version = "1.4.9";
      pname = "obsidian-meta-bind-plugin";
      hashes = {
        manifest = "sha256:d6a43929b67dcf62e6daa94560c527680646afa69aa96c21b8b03e44e0854a1e";
        main = "sha256:99f60f4db8295fedc4b7014f2d341027500f43294b810b1a9cd00cecbb79821f";
        styles = "sha256:02bdee47f0e9173e52df663f92730d2cd26892ab510b572ce6d65503f6427f17";
      };
    };
    settings = {
      "devMode" = false;
      "ignoreCodeBlockRestrictions" = false;
      "preferredDateFormat" = "YYYY-MM-DD";
      "firstWeekday" = {
        "index" = 1;
        "name" = "Sunday";
        "shortName" = "Su";
      };
      "syncInterval" = 200;
      "enableJs" = false;
      "viewFieldDisplayNullAsEmpty" = false;
      "enableSyntaxHighlighting" = true;
      "enableEditorRightClickMenu" = true;
      "inputFieldTemplates" = [ ];
      "buttonTemplates" = [ ];
      "excludedFolders" = [
        "_templates"
      ];
    };
  };

  jsEngine = {
    pkg = mkPlugin {
      repo = "mProjectsCode/obsidian-js-engine-plugin";
      version = "0.3.5";
      pname = "obsidian-js-engine-plugin";
      hashes = {
        manifest = "sha256:a138c322a59e1d1b911be28c5fb2ef3ad63778434b020b5bb440d5c97f7d872d";
        main = "sha256:5913472073b68af7665dbf83b27041538167c83d7edfb8becc3a821ff9665d8c";
        styles = "sha256:d183d8d88730dd8c7bb15ddf11de7347bea2719547b50048c054d4027b5ac599";
      };
    };
  };

  shikiHighlighter = {
    pkg = mkPlugin {
      repo = "mProjectsCode/obsidian-shiki-plugin";
      version = "0.7.7";
      pname = "obsidian-shiki-plugin";
      hashes = {
        manifest = "sha256:be23d7efe11afcd12f929b9c741c98b3ef335937cfcba1f762b43de6c77fd791";
        main = "sha256:b82bfad0caa11b91abb9014c347b4a9faef9575bd63d75b129bb027aab5e60c0";
        styles = "sha256:ccac7b68b996db9d53264cb789688579b142b4725142210af54f311e9b665525";
      };
    };
    settings = {
      "disabledLanguages" = [ ];
      "customThemeFolder" = "";
      "customLanguageFolder" = "";
      "darkTheme" = "obsidian-theme";
      "lightTheme" = "obsidian-theme";
      "preferThemeColors" = true;
      "inlineHighlighting" = true;
      "ecDefaultShowLineNumbers" = false;
      "ecDefaultWrap" = false;
      "ecDefaultFrame" = "none";
    };
  };

  collapsibleCodeBlocks = {
    pkg = mkPlugin {
      repo = "bwya77/collapsible-code-blocks";
      version = "1.0.6";
      pname = "collapsible-code-blocks";
      hashes = {
        manifest = "sha256:59d21a58fe00d01a153b76d6639cf1bc572115be980a381634441ead105ea68c";
        main = "sha256:aab7dfc6b589d3006178bd603c70169b8396dc28abf3d643e4daffd64c522933";
        styles = "sha256:4f2de342f0d79b67138c1827ec24939588542c76ddddc6340566452ba6a7383f";
      };
    };
    settings = {
      "defaultCollapsed" = false;
      "collapseIcon" = ">";
      "expandIcon" = "<";
      "enableHorizontalScroll" = true;
      # have first line be context and highlight it with ```lang {1}
      "collapsedLines" = 1;
      "buttonAlignment" = "left";
      "transparentButton" = false;
    };
  };

  metadataHider = {
    pkg = mkPlugin {
      repo = "Benature/obsidian-metadata-hider";
      version = "1.0.2";
      pname = "obsidian-metadata-hider";
      hashes = {
        manifest = "sha256-4DR4T1rYU7ubVEJiPPC8OsiC2Waqe4zceJdt8lMV9vs=";
        main = "sha256-j/6ZBAl/8a7sWlYmOjQ95YgMI4jqCZVehg2+ErrWm3g=";
        styles = "sha256-utJZCbaByOorMcOjAkw9t7Yd7XW0bcUdlcykJ0JdouM=";
      };
    };
    settings = {
      "autoFold" = true;
      "hideEmptyEntry" = true;
      "hideEmptyEntryInSideDock" = false;
      "propertiesVisible" = "";
      "propertyHideAll" = "hide";
      "entries" = [ ];
    };
  };

  frontmatterViewmode = {
    pkg = mkPlugin {
      repo = "yunidev-uk/obsidian-frontmatter-viewmode";
      version = "1.0.3";
      pname = "obsidian-frontmatter-viewmode";
      hashes = {
        manifest = "sha256-bzBc2K13Cg4vlkkFRzX8FFiMKtdi9blRvpdv5NPsTxM=";
        main = "sha256-jW8uiXOVs2t48Vhd1VVBT1g7p0tpvkhPn8czZci8ROo=";
      };
    };
    settings = {
      "autoFold" = true;
      "hideEmptyEntry" = true;
      "hideEmptyEntryInSideDock" = false;
      "propertiesVisible" = "";
      "propertyHideAll" = "hide";
      "entries" = [ ];
    };
  };

  jupymd = {
    pkg = mkPlugin {
      repo = "d-eniz/jupymd";
      version = "1.7.0";
      pname = "jupymd";
      hashes = {
        manifest = "sha256:3a324148fb4b9e6b9e6a2dcfb02ae309fb213f21dfcbab392df2dd656a22a21f";
        main = "sha256:61b8a581fb34e836dc76607ad92f19ad73e272a5d82209b78c10a8df8da72b86";
        styles = "sha256:d7c82ed859ee3233d057dda47be29841729f52c49761a3543e477751029ab80d";
      };
    };
    settings = {
      "autoSync" = false;
      "bidirectionalSync" = false;
      "autoConvertToNotebookOnRun" = true;
      "pythonInterpreter" =
        "/home/${config.home.username}/Documents/Obsidian/jupython";
      "notebookEditorCommand" = "jupyter-lab";
      "enableCodeBlocks" = true; # uses prismjs instead expressive-code
    };
  };

  templater = {
    pkg = mkPlugin {
      repo = "SilentVoid13/Templater";
      version = "2.20.4";
      pname = "templater-obsidian";
      hashes = {
        manifest = "sha256:0d821a9f102429f83834b7ff94a80b99d700752d5cf152644726416c99a31871";
        main = "sha256:8ab28958ad8e25f81a4c2c7c1d40f1ebdc05d742006ffcf1c5b988979fba0259";
        styles = "sha256:7d85bcd129e9f38a8932455bdf05c9629ce466ab1236dc933b7b7aea55350c04";
      };
    };
    settings = {
      "command_timeout" = 5;
      "templates_folder" = "_templates/templater";
      "templates_pairs" = [
        [
          ""
          ""
        ]
      ];
      "trigger_on_file_creation" = false;
      "auto_jump_to_cursor" = false;
      "enable_system_commands" = true;
      "shell_path" = "";
      "user_scripts_folder" = "";
      "enable_folder_templates" = true;
      "folder_templates" = [
        {
          "folder" = "";
          "template" = "";
        }
      ];
      "enable_file_templates" = false;
      "file_templates" = [
        {
          "regex" = ".*";
          "template" = "";
        }
      ];
      "syntax_highlighting" = true;
      "syntax_highlighting_mobile" = false;
      "enabled_templates_hotkeys" = [
        ""
      ];
      "startup_templates" = [
        ""
      ];
      "intellisense_render" = 1;
      "ignore_folders_on_creation" = [
        {
          "folder" = "";
        }
      ];
    };
  };

  # https://publish.obsidian.md/tasks/Introduction
  tasks = {
    pkg = mkPlugin {
      repo = "obsidian-tasks-group/obsidian-tasks";
      version = "8.0.0";
      pname = "obsidian-tasks-plugin";
      hashes = {
        manifest = "sha256:150cec115dfd83f2f95c4edd515df7254e1102c116032bd0998dc90d67138737";
        main = "sha256:7a47cc91576d2a78932f925073a8688cfcb06bc1fdfa19565043f8ab9979ab56";
        styles = "sha256:62865e01fbaf8418635c0eeacc27d4f7352c90f07e81b1be396acd1a1f7eabbc";
      };
    };
    settings = {
      "presets" = {
        "this_file" = "path includes {{query.file.path}}";
        "this_folder" = "folder includes {{query.file.folder}}";
        "this_folder_only" =
          "filter by function task.file.folder === query.file.folder";
        "this_root" = "root includes {{query.file.root}}";
        "hide_date_fields" =
          "hide due date\nhide scheduled date\nhide start date\nhide created date\nhide done date\nhide cancelled date";
        "hide_non_date_fields" =
          "hide id\nhide depends on\nhide recurrence rule\nhide on completion\nhide priority";
        "hide_query_elements" =
          "hide toolbar\nhide postpone button\nhide edit button\nhide backlinks";
        "hide_everything" =
          "preset hide_date_fields\npreset hide_non_date_fields\npreset hide_query_elements";
        "this_recurring" =
          "hide toolbar\nhappens on or before today\nnot done\nshort mode\nhide recurrence rule\nhide scheduled date\nhide postpone button\nhide edit button\nhide backlink";
        "this_today_daily" =
          "hide toolbar\nhide edit button\nfilter by function task.file.property('tags').contains('#daily')\nfilter by function task.file.property('date') === new Date().toLocaleDateString('en-CA')";
        "this_older_daily" =
          "not done\nhide toolbar\nhide edit button\nfilter by function task.file.property('tags').contains('#daily')\nfilter by function task.file.property('date') < new Date().toLocaleDateString('en-CA')";
      };
      "globalQuery" = "";
      "globalFilter" = "";
      "removeGlobalFilter" = false;
      "taskFormat" = "tasksPluginEmoji";
      "setCreatedDate" = false;
      "setDoneDate" = true;
      "setCancelledDate" = false;
      "autoSuggestInEditor" = true;
      "autoSuggestMinMatch" = 0;
      "autoSuggestMaxItems" = 20;
      "provideAccessKeys" = true;
      "useFilenameAsScheduledDate" = false;
      "filenameAsScheduledDateFormat" = "";
      "filenameAsDateFolders" = [ ];
      "recurrenceOnNextLine" = true;
      "removeScheduledDateOnRecurrence" = false;
      "searchResults" = {
        "taskCountLocation" = "top";
      };
      "statusSettings" = {
        "coreStatuses" = [
          {
            "symbol" = " ";
            "name" = "Todo";
            "nextStatusSymbol" = "x";
            "availableAsCommand" = true;
            "type" = "TODO";
          }
          {
            "symbol" = "x";
            "name" = "Done";
            "nextStatusSymbol" = " ";
            "availableAsCommand" = true;
            "type" = "DONE";
          }
        ];
        "customStatuses" = [
          {
            "symbol" = "/";
            "name" = "In Progress";
            "nextStatusSymbol" = "x";
            "availableAsCommand" = true;
            "type" = "IN_PROGRESS";
          }
          {
            "symbol" = "-";
            "name" = "Cancelled";
            "nextStatusSymbol" = " ";
            "availableAsCommand" = true;
            "type" = "CANCELLED";
          }
        ];
      };
      "isShownInEditModal" = {
        "priority" = true;
        "recurrence" = true;
        "due" = true;
        "scheduled" = true;
        "start" = true;
        "before_this" = true;
        "after_this" = true;
        "status" = true;
        "created" = true;
        "done" = true;
        "cancelled" = true;
      };
      "features" = {
        "INTERNAL_TESTING_ENABLED_BY_DEFAULT" = true;
      };
      "generalSettings" = { };
      "headingOpened" = {
        "Core Statuses" = true;
        "Custom Statuses" = true;
      };
      "debugSettings" = {
        "ignoreSortInstructions" = false;
        "showTaskHiddenData" = false;
        "recordTimings" = false;
      };
      "loggingOptions" = {
        "minLevels" = {
          "" = "info";
          "tasks" = "info";
          "tasks.Cache" = "info";
          "tasks.Events" = "info";
          "tasks.File" = "info";
          "tasks.Query" = "info";
          "tasks.Task" = "info";
        };
      };
    };
  };

  # https://tasknotes.dev/
  tasknotes = {
    pkg = mkPlugin {
      repo = "callumalpass/tasknotes";
      version = "4.7.2";
      pname = "tasknotes";
      hashes = {
        manifest = "sha256:68381a3c17aecf586b5ac081f6ec45592efa5735e37ee260cbbda2c283175e43";
        main = "sha256:f1f8c7e5a0e0bba19464790d7b1e36b1a9f0088d7e259a5bdaadd50f693ab316";
        styles = "sha256:7d36c0741e747b5e7d361df32b5d75ec46d1eb69dd82881bc902094147b271d9";
      };
    };
  };

  # https://github.com/vrtmrz/obsidian-livesync
  liveSync = {
    pkg = mkPlugin {
      repo = "vrtmrz/obsidian-livesync";
      version = "0.25.83";
      pname = "obsidian-livesync";
      hashes = {
        manifest = "sha256:4944f5665c94bcbb58db0e3708ec2bd8ee36118791271c01d085668876dc8ba6";
        main = "sha256:5e57f990635ab0cf2ff3879f3c6cb91ddfdbc146958d33d1e5d21f1869dff6a4";
        styles = "sha256:37d31798186d7e97ea979e6d2aae8021ea1ac1df2c3b9d2b03dce269959c27f3";
      };
    };
  };

  # https://github.com/Vinzent03/obsidian-git
  # https://publish.obsidian.md/git-doc/Start+here
  git = {
    pkg = mkPlugin {
      repo = "Vinzent03/obsidian-git";
      version = "2.38.6";
      pname = "obsidian-git";
      hashes = {
        manifest = "sha256:67391efa84093d56011f43764ff4f1c846dd8ad52b1f1dfd010ab628b217c2a3";
        main = "sha256:31ad89d3d973cb5520647d527f50d8c23fcd42176768361741a543af56d56287";
        styles = "sha256:f5ab93f4d5b4dd1bd1e577864c5c79087f7adfd448ac346e0489e5847ce6922d";
      };
    };
  };
}
