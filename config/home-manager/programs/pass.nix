# programs/pass.nix
{
  pkgs,
  config,
  inputs,
  ...
}:
{
  xdg.desktopEntries.keepassxc = {
    name = "KeePassXC";
    exec = "env QT_SCALE_FACTOR=0.75 /usr/bin/keepassxc";
    icon = "keepassxc";
    categories = [ "Utility" ];
    type = "Application";
    startupNotify = true;
  };

  home.packages = with pkgs; [
    pass
    pinentry-all
    kdePackages.kleopatra
    (pkgs.symlinkJoin {
      name = "pinentry-rofi-wrapped";
      buildInputs = [ pkgs.makeWrapper ];
      paths = [ pkgs.pinentry-rofi ];
      postBuild = ''
        wrapProgram $out/bin/pinentry-rofi \
          --add-flags "-- -theme ${config.xdg.configHome}/rofi/Pinentry.rasi"
      '';
    })
  ];

  # https://wiki.archlinux.org/title/XDG_Base_Directory
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };
  # Ensure directory exists with secure permissions
  home.activation.ensureGnuPGDir =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        mkdir -p ${config.xdg.dataHome}/{pass,gnupg}
        chmod 700 ${config.xdg.dataHome}/{pass,gnupg}
      '';

  # Override gpg-agent systemd user unit to pass GNUPGHOME
  systemd.user.services."gpg-agent" = {
    Unit = {
      Description = "GnuPG cryptographic agent and passphrase cache";
      Documentation = [ "man:gpg-agent(1)" ];
      Requires = "gpg-agent.socket";
    };
    Service = {
      Environment = "GNUPGHOME=${config.xdg.dataHome}/gnupg";
      ExecReload = "/usr/bin/gpgconf --reload gpg-agent";
      ExecStart = "/usr/bin/gpg-agent --supervised";
      Restart = "on-abort";
    };
  };
}
