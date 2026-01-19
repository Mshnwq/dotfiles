{
  lib,
  pkgs,
  config,
  ...
}:
let
  plugins = pkgs.callPackage ./plugins.nix { inherit pkgs; };
in
{
  options.obsidian.syncthing.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkMerge [
    {
      programs.obsidian = {
        enable = true;
        defaultSettings = {
          communityPlugins = with plugins; [
            pywalPlugin
            advancedUri
          ];
        };
        vaults = {
          "Home" = {
            enable = true;
            target = "Documents/Obsidian/Home";
          };
          "Dummy" = {
            enable = true;
            target = "Documents/Obsidian/Dummy";
          };
        };
      };
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
