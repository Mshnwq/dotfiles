{
  lib,
  pkgs,
  config,
  ...
}:
let
  theme = ''
    color info              color8 color0
    color background        color2 color0
    color listfocus         color8 color0 standout
    color listnormal        color3 color0
    color listfocus_unread  color8 color0 standout
    color listnormal_unread color4 color0
    highlight feedlist ".*0/0..---.*" color0 color0 invis
    highlight feedlist "---.*---"     color8 color0 standout
    search-highlight-colors    color6 color0
    searchresult-title-format "Search result"
    color article color7 default bold
    highlight article "^(Feed|Title|Author|Link|Date): .+" color6 color0 bold
    highlight article "^(Feed|Title|Author|Link|Date):"    color5 color0 bold
    highlight article "https?://[^ ]+"    color4 color0 underline
    highlight article "\\[[0-9][0-9]*\\]" color6 color0 bold
  '';
  binds = ''
    macro b set browser "Firefox %u" ; open-in-browser
    macro m set browser "w3m %u" ; open-in-browser
    macro c set browser "echo %u | wl-copy" ; open-in-browser
    macro v set browser "sh -c 'nohup setsid Mpv %u --profile=transparent %u >/dev/null 2>&1 &'" ; open-in-browser
    macro d set browser "yt-dlp -o '~/Downloads/News/%(title)s.%(ext)s' %u" ; open-in-browser
    # macro y set browser "~/.local/bin/executer/.kitty-yt-img.sh %u" ; open-in-browser
    bind-key G end
    bind-key g home
    bind-key K pageup
    bind-key J pagedown
    bind-key U show-urls
    bind-key n next-unread
    bind-key N prev-unread
    bind-key a toggle-article-read
  '';
  # TODO: |
  # https://github.com/newsboat/newsboat/blob/master/contrib/fltr-substack/README.md
  # https://www.youtube.com/watch?v=XKOQb0f0OTg
  # https://github.com/newsboat/newsboat/blob/master/contrib/image-preview/README.org
  # https://github.com/Jocomol/newsboat_video_downloader
in
{
  sops.secrets = {
    news-urls = {
      mode = "0400";
      path = "${config.xdg.configHome}/newsboat/urls";
    };
  };

  # https://newsboat.org/releases/2.24/docs/newsboat.html
  # https://wiki.archlinux.org/title/Newsboat
  programs.newsboat = {
    enable = true;
    reloadThreads = 8;
    autoReload = false;
    extraConfig = lib.concatStringsSep "\n" [
      theme
      binds
    ];
  };

  # Lifecycle: socket triggers → proxy starts → container starts → idle timeout → all stop
  # This socket stays active and listens for incoming connections
  systemd.user.sockets.rumblerss-proxy = {
    Unit = {
      Description = "Rumble RSS Proxy Socket";
    };
    Socket = {
      ListenStream = "127.0.0.1:8030";
      KeepAliveIntervalSec = 5;
      KeepAliveTimeSec = 15;
      KeepAliveProbes = 3;
      KeepAlive = true;
    };
    Install = {
      WantedBy = [ "sockets.target" ];
    };
  };

  # https://thinkaboutit.tech/posts/2025-07-20-adhoc-containers-with-systemd-and-quadlet/
  # Bridges between the socket and the podman quadlet container
  systemd.user.services.rumblerss-proxy = {
    Unit = {
      Description = "Rumble RSS Proxy Service";
      Requires = [ "rumblerss.service" ];
      After = [ "rumblerss.service" ];
      StopWhenUnneeded = true;
    };
    Service = {
      Restart = "no";
      Type = "notify";
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=15 127.0.0.1:8031";
    };
  };

  # https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
  # https://github.com/porjo/rumblerss
  home.file.".config/containers/systemd/rumblerss.container".text = ''
    [Unit]
    Description=Rumble RSS Feed Generator
    BindsTo=rumblerss-proxy.service

    [Container]
    Image=ghcr.io/porjo/rumblerss:latest
    PublishPort=127.0.0.1:8031:8080
    AutoUpdate=registry

    [Service]
    Restart=on-failure
    TimeoutStopSec=5

    # Empty WantedBy = don't auto-start on boot
    # Container only starts when proxy service requires it
    [Install]
    WantedBy=
  '';
}
