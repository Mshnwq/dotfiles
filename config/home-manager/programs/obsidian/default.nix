# {
#   lib,
#   pkgs,
#   config,
#   inputs,
#   ...
# }:
# let
#   plugins = pkgs.callPackage ./plugins.nix { inherit pkgs; };
#   obsidian-dir = "Documents/Obsidian";
#   vaults = {
#     Home = {
#       enable = true;
#       target = "${obsidian-dir}/Home";
#     };
#     Dummy = {
#       enable = true;
#       target = "${obsidian-dir}/Dummy";
#       settings = {
#         # move to global when figured it all
#         hotkeys = import ./hotkeys.nix { };
#         app = {
#           "attachmentFolderPath" = "Assets";
#           "alwaysUpdateLinks" = true;
#           "showInlineTitle" = false;
#           "trashOption" = "local";
#           "spellcheck" = false;
#           "vimMode" = true;
#         };
#         corePlugins = [
#           # "audio-recorder"
#           "backlink"
#           "bases"
#           # "bookmarks"
#           "canvas"
#           "command-palette"
#           "daily-notes"
#           "editor-status"
#           "file-explorer"
#           "file-recovery"
#           # "footnotes"
#           "global-search"
#           "graph"
#           # "markdown-importer"
#           "note-composer"
#           "outgoing-link"
#           "outline"
#           "page-preview"
#           "properties"
#           # "publish"
#           # "random-note"
#           # "slash-command"
#           # "slides"
#           "switcher"
#           # "sync"
#           "tag-pane"
#           {
#             name = "templates";
#             settings = {
#               "folder" = "Templates";
#             };
#           }
#           # "webviewer"
#           "word-count"
#           # "workspaces"
#           # "zk-prefixer"
#         ];
#       };
#     };
#   };
#   vaultDirs = map (v: builtins.baseNameOf v.target) (builtins.attrValues vaults);
# in
# {
#   options.obsidian.syncthing.enable = lib.mkOption {
#     type = lib.types.bool;
#     default = false;
#   };
#
#   config = lib.mkMerge [
#     {
#       home.packages = with pkgs; [
#         # https://github.com/charmbracelet/glow/issues/342#issuecomment-3731554599
#         # Note: bad, only works for simple graphs :(
#         # mermaid-ascii # from /pkgs/
#         glow
#       ];

      # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.obsidian
      programs.obsidian = {
        enable = true;
        vaults = vaults;
        # global settings
        defaultSettings = {
          communityPlugins = with plugins; [
            # advancedUri
            excalidraw
          ];
          cssSnippets = import ./snippets.nix { inherit pkgs; };
          appearance = {
            "cssTheme" = "pywal-theme"; # no need theme = {} with my init script
            "showRibbon" = false;
            # "showViewHeader" = false; # First figure out how to access the options list
          };
        };
      };

      home.activation.obsidianInit =
        inputs.home-manager.lib.hm.dag.entryAfter [ "obsidian" ]
          ''
            for vault in ${lib.concatStringsSep " " vaultDirs}; do
              theme_dir="${obsidian-dir}/$vault/.obsidian/themes/pywal-theme"
              if [ ! -f "$theme_dir/manifest.json" ]; then
                mkdir -p "$theme_dir"
                ln -sf \
                  "${config.xdg.cacheHome}/wal/custom-obsidian.css" \
                  "$theme_dir/theme.css"
                ${lib.getExe pkgs.jq} -n \
                  '{ name: "Pywal", version: "1.0.0", author: "Mshnwq" }' \
                  > "$theme_dir/manifest.json"
              fi
            done
            # https://github.com/nix-community/home-manager/blob/master/modules/programs/obsidian.nix#L581
            OBSIDIAN_CONFIG="${config.xdg.configHome}/obsidian/obsidian.json"
            if [ -f "$OBSIDIAN_CONFIG" ] && ! ${lib.getExe pkgs.jq} -e '.frame' "$OBSIDIAN_CONFIG" > /dev/null 2>&1; then
              tmp="$(mktemp)"
              run ${lib.getExe pkgs.jq} '. + {"frame": "native"}' "$OBSIDIAN_CONFIG" > "$tmp"
              run install -m644 "$tmp" "$OBSIDIAN_CONFIG"
              rm -f "$tmp"
            fi
          '';
    }

    (lib.mkIf config.obsidian.syncthing.enable {
      # Lifecycle: socket triggers → proxy starts → container starts → idle timeout → all stop
      systemd.user.sockets.syncthing-proxy = {
        Unit = {
          Description = "Syncthing Proxy Socket";
        };
        Socket = {
          ListenStream = "127.0.0.1:8384";
          KeepAlive = true;
          KeepAliveTimeSec = 15;
          KeepAliveIntervalSec = 5;
          KeepAliveProbes = 3;
        };
        Install = {
          WantedBy = [ "sockets.target" ];
        };
      };

      systemd.user.services.syncthing-proxy = {
        Unit = {
          Description = "Syncthing Proxy Service";
          Requires = [ "syncthing.service" ];
          After = [ "syncthing.service" ];
          StopWhenUnneeded = true;
        };
        Service = {
          Type = "notify";
          ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=15 127.0.0.1:8383";
          Restart = "no";
        };
      };

      # https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
      home.file.".config/containers/systemd/syncthing.container".text = ''
        [Unit]
        Description=Syncthing
        BindsTo=syncthing-proxy.service

        [Container]
        Image=docker.io/syncthing/syncthing:latest
        AutoUpdate=registry
        PublishPort=127.0.0.1:8383:8384
        PublishPort=22000:22000/tcp
        PublishPort=22000:22000/udp
        PublishPort=21027:21027/udp
        UserNS=keep-id:uid=1000,gid=1000
        Volume=%h/.config/syncthing:/var/syncthing/config:Z
        Volume=%h/Documents/Syncthing/share1:/var/syncthing/share1:Z
        Volume=%h/Documents/Syncthing/share2:/var/syncthing/share2:Z

        [Service]
        Restart=on-failure
        TimeoutStopSec=5
        TimeoutStartSec=900

        [Install]
        WantedBy=
      '';
    })
  ];
}
