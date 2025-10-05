{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  # TODO: hide share one
  xdg.desktopEntries.keepassxc-nix = {
    name = "KeePassXC (nix)";
    exec = "env QT_SCALE_FACTOR=0.75 /usr/bin/keepassxc";
    icon = "keepassxc";
    categories = [ "Utility" ];
    type = "Application";
    startupNotify = true;
  };

  home.packages = with pkgs; [
    pass
    #pinentry-all
    pinentry-rofi
  ];

  # Custom wrapper for pinentry
  # TODO: fix blurry
  home.file.".local/bin/pinentry-wofi".text = ''
    #!/usr/bin/env bash
    exec ${pkgs.pinentry-rofi}/bin/pinentry-rofi "$@" -- -theme ${config.xdg.configHome}/rofi/Pinentry.rasi
  '';
  home.file.".local/bin/pinentry-wofi".executable = true;

  # Environment
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };
  # https://wiki.archlinux.org/title/XDG_Base_Directory
  # OpenSSH 		      ~/.ssh 	will not fix 	Assumed to be present by many ssh daemons and clients such as DropBear and OpenSSH.
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

# TEST:
# run ~/.dotfiles/setup/test/pass.sh

# INFO:
# https://wiki.archlinux.org/title/XDG_Base_Directory
# export GNUPGHOME="$XDG_DATA_HOME"/gnupg, gpg2 --homedir "$XDG_DATA_HOME"/gnupg

# Note that this currently does not work out-of-the-box using systemd user units and socket-based activation, since the socket directory changes based on the hash of $GNUPGHOME. You can get the new socket directory using gpgconf --list-dirs socketdir and have to modify the systemd user units to listen on the correct sockets accordingly. You also have to use the following gpg-agent.service drop-in file (or otherwise pass the GNUPGHOME env var to the agent running in systemd), or you might experience issues with "missing" private keys:
#
# [Service]
# Environment="GNUPGHOME=%h/.local/share/gnupg"
#
# If you use GPG as your SSH agent, set SSH_AUTH_SOCK to the output of gpgconf --list-dirs agent-ssh-socket instead of some hardcoded value.
