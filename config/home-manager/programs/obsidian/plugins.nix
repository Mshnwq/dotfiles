# programs/obsidian/plugins.nix
{
  pkgs,
  config,
  ...
}:
{
  advancedUri =
    let
      version = "1.46.1";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/manifest.json";
        hash = "sha256:fa12d5488bf1d61b829272b15de72fea27d1f2d6ac854f97ec97a6cc2784c2f1";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/${version}/main.js";
        hash = "sha256:d10300fb667eb9e93417427fc3ea010f46db020885d29c5decc78735c14ab162";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-advanced-uri";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${manifestJson} $out/manifest.json
          cp ${mainJs} $out/main.js
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
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/manifest.json";
        hash = "sha256:e4788bd00c9890f62c939d51676ed2eaa392748a738f292d47721df6fe100553";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/main.js";
        hash = "sha256:8f7d5dc538228020805a255db9615ba2fdb82a9c0e6081f1b37ee7c2750ab37e";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/download/${version}/styles.css";
        hash = "sha256:5581af67d9a8cc133774420c7974d03a7cbcb5ebce209d6e8e0a53e00bde3f00";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-excalidraw-plugin";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${stylesCss} $out/styles.css
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
    };

  nodeFactor =
    let
      version = "3.0.0";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/CalfMoon/node-factor/releases/download/${version}/manifest.json";
        hash = "sha256:6b95c3e67c2c72af9a3c8e46b9cceb96158b1ac2932ca6481151f3b9f271a211";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/CalfMoon/node-factor/releases/download/${version}/main.js";
        hash = "sha256:d9cacb6d0bb2e0a99a129412e6924e2c7e9fc4bea4351947529863270d8fbb41";
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
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/manifest.json";
        hash = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/main.js";
        hash = "sha256-a7HPcBCvrYMOc1dfyg4r+9MnnFYuPZ0k8tL0UWHrfQA=";
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
          cp ${stylesCss} $out/styles.css
          cp ${manifestJson} $out/manifest.json
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

  # https://github.com/johansan/notebook-navigator#8-custom-hotkeys
  notebookNavigator =
    let
      version = "2.6.3";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/manifest.json";
        hash = "sha256:5d2cfb1aed3978f7647eecab037316f38420a7db1e745d6c5012d039edbfbc2b";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/main.js";
        hash = "sha256:efba56b71c3f7f9ede5a0fca871fcdb3ee349ed5911849822049780a36b0989a";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/johansan/notebook-navigator/releases/download/${version}/styles.css";
        hash = "sha256:cfd3528c84126ec694e6115d08ddd6e5d57c5b47c360c9d15c4ddcda13ada7bd";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "notebook-navigator";
        version = "${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${stylesCss} $out/styles.css
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
      # settings = builtins.fromJSON (builtins.readFile ./notebookNavigator.json);
    };

  styleSettings =
    let
      version = "1.0.9";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/manifest.json";
        hash = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g=";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/main.js";
        hash = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/styles.css";
        hash = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-style-settings";
        version = "${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${stylesCss} $out/styles.css
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
    };

  # https://aitorllamas.com/obsidian-lovely-bases/
  lovelyBases =
    let
      version = "0.2.2";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/aitorllj93/obsidian-lovely-bases/releases/download/${version}/manifest.json";
        hash = "sha256:1c39e53a9e01f2c4fa8da250b592b8569de24ccec47bfcc6964b361fff1e4a2d";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/aitorllj93/obsidian-lovely-bases/releases/download/${version}/main.js";
        hash = "sha256:f512b3279ad1344d90956380a287e546bd22cdd2a7c386e26a7dd53805b578ec";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/aitorllj93/obsidian-lovely-bases/releases/download/${version}/styles.css";
        hash = "sha256:b5075812a991be0816f773c37f049943b08296a08ffadf43afc090b4d9f6dcdb";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-lovely-bases";
        version = "v${version}";
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp ${mainJs} $out/main.js
          cp ${stylesCss} $out/styles.css
          cp ${manifestJson} $out/manifest.json
          runHook postInstall
        '';
      };
    in
    {
      inherit pkg;
    };

  omnisearch =
    let
      version = "1.28.2";
      mainJs = pkgs.fetchurl {
        url = "https://github.com/scambier/obsidian-omnisearch/releases/download/${version}/main.js";
        hash = "sha256:787e80d61a7f482ae4a69940c8e34f972f9eb264c5c69dd83c50ddde9458a958";
      };
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/scambier/obsidian-omnisearch/releases/download/${version}/manifest.json";
        hash = "sha256:9f741ed48b1017efc73e67fc7cd113e910cb35daf3e6b996e8ba0215c5546dae";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/scambier/obsidian-omnisearch/releases/download/${version}/styles.css";
        hash = "sha256:b70b786c51a899e376fb936954f655908709fe3cb746d98f1ba1f5171852ae2b";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-omnisearch";
        version = "${version}";
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

  calendar =
    let
      version = "1.5.10";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/liamcain/obsidian-calendar-plugin/releases/download/${version}/manifest.json";
        hash = "sha256-8+lYEzhkhRK6oS1bRYSQ9/02eRj3vba9hhcc5Xvn0Is=";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/liamcain/obsidian-calendar-plugin/releases/download/${version}/main.js";
        hash = "sha256-f7M56c+f2+WoAforirhbNmtbN3f70ZPLyHKLwncR0SU=";
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

  metaBind =
    let
      version = "1.4.9";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-meta-bind-plugin/releases/download/${version}/manifest.json";
        hash = "sha256:d6a43929b67dcf62e6daa94560c527680646afa69aa96c21b8b03e44e0854a1e";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-meta-bind-plugin/releases/download/${version}/main.js";
        hash = "sha256:99f60f4db8295fedc4b7014f2d341027500f43294b810b1a9cd00cecbb79821f";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-meta-bind-plugin/releases/download/${version}/styles.css";
        hash = "sha256:02bdee47f0e9173e52df663f92730d2cd26892ab510b572ce6d65503f6427f17";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-meta-bind-plugin";
        version = "${version}";
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
    };

  shikiHighlighter =
    let
      version = "0.7.7";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-shiki-plugin/releases/download/${version}/manifest.json";
        hash = "sha256:be23d7efe11afcd12f929b9c741c98b3ef335937cfcba1f762b43de6c77fd791";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-shiki-plugin/releases/download/${version}/main.js";
        hash = "sha256:b82bfad0caa11b91abb9014c347b4a9faef9575bd63d75b129bb027aab5e60c0";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/mProjectsCode/obsidian-shiki-plugin/releases/download/${version}/styles.css";
        hash = "sha256:ccac7b68b996db9d53264cb789688579b142b4725142210af54f311e9b665525";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-shiki-plugin";
        version = "${version}";
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

  collapsibleCodeBlocks =
    let
      version = "1.0.6";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/bwya77/collapsible-code-blocks/releases/download/${version}/manifest.json";
        hash = "sha256:59d21a58fe00d01a153b76d6639cf1bc572115be980a381634441ead105ea68c";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/bwya77/collapsible-code-blocks/releases/download/${version}/main.js";
        hash = "sha256:aab7dfc6b589d3006178bd603c70169b8396dc28abf3d643e4daffd64c522933";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/bwya77/collapsible-code-blocks/releases/download/${version}/styles.css";
        hash = "sha256:4f2de342f0d79b67138c1827ec24939588542c76ddddc6340566452ba6a7383f";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "collapsible-code-blocks";
        version = "${version}";
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

  metadataHider =
    let
      version = "1.0.2";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/Benature/obsidian-metadata-hider/releases/download/${version}/manifest.json";
        hash = "sha256-4DR4T1rYU7ubVEJiPPC8OsiC2Waqe4zceJdt8lMV9vs=";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/Benature/obsidian-metadata-hider/releases/download/${version}/main.js";
        hash = "sha256-j/6ZBAl/8a7sWlYmOjQ95YgMI4jqCZVehg2+ErrWm3g=";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/Benature/obsidian-metadata-hider/releases/download/${version}/styles.css";
        hash = "sha256-utJZCbaByOorMcOjAkw9t7Yd7XW0bcUdlcykJ0JdouM=";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-metadata-hider";
        version = "${version}";
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
        "autoFold" = true;
        "hideEmptyEntry" = true;
        "hideEmptyEntryInSideDock" = false;
        "propertiesVisible" = "";
        "propertyHideAll" = "hide";
        "entries" = [ ];
      };
    };

  frontmatterViewmode =
    let
      version = "1.0.3";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/yunidev-uk/obsidian-frontmatter-viewmode/releases/download/${version}/manifest.json";
        hash = "sha256-bzBc2K13Cg4vlkkFRzX8FFiMKtdi9blRvpdv5NPsTxM=";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/yunidev-uk/obsidian-frontmatter-viewmode/releases/download/${version}/main.js";
        hash = "sha256-jW8uiXOVs2t48Vhd1VVBT1g7p0tpvkhPn8czZci8ROo=";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-frontmatter-viewmode";
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
        "autoFold" = true;
        "hideEmptyEntry" = true;
        "hideEmptyEntryInSideDock" = false;
        "propertiesVisible" = "";
        "propertyHideAll" = "hide";
        "entries" = [ ];
      };
    };

  jupymd =
    let
      version = "1.7.0";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/d-eniz/jupymd/releases/download/${version}/manifest.json";
        hash = "sha256:3a324148fb4b9e6b9e6a2dcfb02ae309fb213f21dfcbab392df2dd656a22a21f";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/d-eniz/jupymd/releases/download/${version}/main.js";
        hash = "sha256:61b8a581fb34e836dc76607ad92f19ad73e272a5d82209b78c10a8df8da72b86";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/d-eniz/jupymd/releases/download/${version}/styles.css";
        hash = "sha256:d7c82ed859ee3233d057dda47be29841729f52c49761a3543e477751029ab80d";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "jupymd";
        version = "${version}";
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
        "autoSync" = false;
        "bidirectionalSync" = false;
        "autoConvertToNotebookOnRun" = true;
        "pythonInterpreter" =
          "/home/${config.home.username}/Documents/Obsidian/jupython";
        "notebookEditorCommand" = "jupyter-lab";
        "enableCodeBlocks" = true; # uses prismjs instead expressive-code
      };
    };

  templater =
    let
      version = "2.20.4";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/SilentVoid13/Templater/releases/download/${version}/manifest.json";
        hash = "sha256:0d821a9f102429f83834b7ff94a80b99d700752d5cf152644726416c99a31871";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/SilentVoid13/Templater/releases/download/${version}/main.js";
        hash = "sha256:8ab28958ad8e25f81a4c2c7c1d40f1ebdc05d742006ffcf1c5b988979fba0259";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/SilentVoid13/Templater/releases/download/${version}/styles.css";
        hash = "sha256:7d85bcd129e9f38a8932455bdf05c9629ce466ab1236dc933b7b7aea55350c04";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "templater-obsidian";
        version = "${version}";
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
  tasks =
    let
      version = "8.0.0";
      manifestJson = pkgs.fetchurl {
        url = "https://github.com/obsidian-tasks-group/obsidian-tasks/releases/download/${version}/manifest.json";
        hash = "sha256:150cec115dfd83f2f95c4edd515df7254e1102c116032bd0998dc90d67138737";
      };
      mainJs = pkgs.fetchurl {
        url = "https://github.com/obsidian-tasks-group/obsidian-tasks/releases/download/${version}/main.js";
        hash = "sha256:7a47cc91576d2a78932f925073a8688cfcb06bc1fdfa19565043f8ab9979ab56";
      };
      stylesCss = pkgs.fetchurl {
        url = "https://github.com/obsidian-tasks-group/obsidian-tasks/releases/download/${version}/styles.css";
        hash = "sha256:62865e01fbaf8418635c0eeacc27d4f7352c90f07e81b1be396acd1a1f7eabbc";
      };
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "obsidian-tasks-plugin";
        version = "${version}";
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
}
