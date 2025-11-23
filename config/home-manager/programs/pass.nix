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
  # OpenSSH 		      ~/.ssh 	will not be fix -	Assumed to be present by many ssh daemons and clients such as DropBear and OpenSSH.
  # SSH folder 		    ~/.ssh 			700 	drwx------
  # Public key 		    ~/.ssh/id_rsa.pub 	644 	-rw-r--r--
  # Private key 	    ~/.ssh/id_rsa 		600 	-rw-------
  # Authorized Keys 	~/.ssh/authorized_keys 	600 	-rw-------
  # Config 		        ~/.ssh/config 		600 	-rw-------

  # Ensure directory exists with secure permissions
  home.activation.ensureGnuPGDir =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        mkdir -p ${config.xdg.dataHome}/gnupg
        chmod 700 ${config.xdg.dataHome}/gnupg
        mkdir -p ${config.xdg.dataHome}/pass
        chmod 700 ${config.xdg.dataHome}/pass
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
      ExecStart = "/usr/bin/gpg-agent --supervised";
      ExecReload = "/usr/bin/gpgconf --reload gpg-agent";
      Restart = "on-abort";
    };
  };
}

# TODO: find way to sync all
# for now manually do it
# Source:
#   (gpg)
#     - gpg --export-secret-keys --armor KEY_ID > XXX-priv.asc
#     - gpg --export             --armor KEY_ID > XXX-pub.asc
#     - gpg --export-ownertrust > trust.txt
#   (pass)
#     - tar -czf backup.tar.gz -C ~/.pass .
# Destination:
#   (gpg)
#     - gpg --import XXX-priv.asc
#     - gpg --import XXX-pub.asc
#     - gpg --import-ownertrust trust.txt
#   (pass)
#     - tar -xzf backup.tar.gz

# TEST:
# run ~/.dotfiles/setup/test/pass.sh

# INFO:
# Note that this currently does not work out-of-the-box using systemd user units and socket-based activation, since the socket directory changes based on the hash of $GNUPGHOME. You can get the new socket directory using gpgconf --list-dirs socketdir and have to modify the systemd user units to listen on the correct sockets accordingly. You also have to use the following gpg-agent.service drop-in file (or otherwise pass the GNUPGHOME env var to the agent running in systemd), or you might experience issues with "missing" private keys:
#
# [Service]
# Environment="GNUPGHOME=%h/.local/share/gnupg"
#
# If you use GPG as your SSH agent, set SSH_AUTH_SOCK to the output of gpgconf --list-dirs agent-ssh-socket instead of some hardcoded value.
