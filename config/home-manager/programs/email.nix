# programs/email.nix
{
  pkgs,
  config,
  ...
}:
let
  # https://home-manager.dev/manual/unstable/options.xhtml#opt-accounts.email.accounts
  mkEmailAccount = name: secrets: {
    realName = secrets.realName;
    address = secrets.address;
    userName = secrets.address;
    primary = secrets.isPrimary;
    signature = {
      showSignature = "append";
      text = secrets.realName;
    };
    imap = {
      host = secrets.imap.host;
      port = secrets.imap.port;
    };
    smtp = {
      host = secrets.smtp.host;
      port = secrets.smtp.port;
    };
    mbsync = {
      enable = true;
      create = "maildir";
      patterns = [ "*" ];
    };
    passwordCommand = secrets.passwordCommand;
    neomutt.enable = false;
    aerc.enable = true;
  };
  emailsPath = "${config.xdg.configHome}/emails.json";
  mailDir = "${config.home.homeDirectory}/Documents/Mail";
in
{
  sops.secrets = {
    emails = {
      mode = "0400";
      path = emailsPath;
    };
  };
  accounts.email = {
    maildirBasePath = mailDir;
    accounts = builtins.mapAttrs mkEmailAccount (
      builtins.fromJSON (builtins.readFile emailsPath)
    );
  };
  home.packages = with pkgs; [
    dante # for socksify
  ];

  programs = {
    # ~/.config/isyncrc
    mbsync.enable = true;
    # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.aerc.enable
    aerc = {
      enable = true;
      # https://man.archlinux.org/man/aerc-config.5.en
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
          styleset-name = "default";
        };
        viewer = {
          show-images = true;
        };
        ui = {
          mouse-enabled = true;
        };
        # https://github.com/open-community-docs/aerc-docs/blob/main/src/content/docs/
        filters = {
          "subject,~^\\[PATCH" = "awk -f ${config.xdg.configHome}/aerc/filters/hldiff";
          "text/plain" = "awk -f ${config.xdg.configHome}/aerc/filters/plain";
          "text/html" = "! ${config.xdg.configHome}/aerc/filters/html";
        };
        templates = {
          template-dirs = "${config.xdg.configHome}/aerc/templates/";
        };
      };
    };
  };
}
