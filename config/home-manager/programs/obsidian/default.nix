{
  lib,
  pkgs,
  ...
}:
let
  plugins = pkgs.callPackage ./plugins.nix { inherit pkgs; };
in
{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = with plugins; [
        pywalPlugin
        # advancedUri # TODO: broked
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
  
  # TODO: 
  # home.file = {
  #   ".config/containers/systemd/syncthing.socket".text = ''
  #     [Unit]
  #     Description=Syncthing Socket
  #     Wants=network-online.target
  #     After=network-online.target
  #     [Socket]
  #     ListenStream=127.0.0.1:3000
  #     [Install]
  #     WantedBy=sockets.target
  #   '';
  #   ".config/containers/systemd/syncthing.container".text = ''
  #     [Unit]
  #     Description=Syncthing Socket
  #     Requires=syncthing.socket
  #     After=syncthing.socket
  #     [Service]
  #     Restart=no
  #     TimeoutStartSec=900
  #     TimeoutStopSec=10
  #     [Container]
  #     Image=docker.io/syncthing/syncthing:latest
  #     AutoUpdate=registry
  #     PublishPort=127.0.0.1:8384:8384
  #     PublishPort=22000:22000/tcp
  #     PublishPort=22000:22000/udp
  #     PublishPort=21027:21027/udp
  #     UserNS=keep-id:uid=1000,gid=1000
  #     Volume=%h/.config/syncthing:/var/syncthing/config:Z
  #     # Folders to share
  #     Volume=%h/Documents/Syncthing/share1:/var/syncthing/share1:Z
  #     Volume=%h/Documents/Syncthing/share2:/var/syncthing/share2:Z
  #   '';
  # };

  # systemd.user.sockets.rumblerss = {
  #   Unit = {
  #     Description = "Rumble RSS Socket";
  #   };
  #   Socket = {
  #     ListenStream = "127.0.0.1:3000";
  #   };
  #   Install = {
  #     WantedBy = [ "sockets.target" ];
  #   };
  # };
}

# [Unit]
# Description=Podman syncthing.service
# Wants=network-online.target
# After=network-online.target
#
# [Service]
# Restart=on-failure
# TimeoutStartSec=900
#
# [Container]
# Image=docker.io/syncthing/syncthing:latest
# AutoUpdate=registry
# PublishPort=127.0.0.1:8384:8384
# PublishPort=22000:22000/tcp
# PublishPort=22000:22000/udp
# PublishPort=21027:21027/udp
# UserNS=keep-id:uid=1000,gid=1000
# Volume=%h/.config/syncthing:/var/syncthing/config:Z
#
# # Folders to share
# Volume=%h/Documents/Syncthing/share1:/var/syncthing/share1:Z
# Volume=%h/Documents/Syncthing/share2:/var/syncthing/share2:Z
#
# [Install]
# WantedBy=default.target
