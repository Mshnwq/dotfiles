# programs/email.nix
{
  pkgs,
  config,
  ...
}:
let
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
    neomutt = {
      enable = true;
      extraConfig = ''
        set edit_headers = yes
        set charset = UTF-8
        unset use_domain
        set use_from = yes
      '';
    };
    mbsync = {
      enable = true;
      create = "maildir";
      patterns = [ "*" ];
    };
    passwordCommand = secrets.passwordCommand;
  };

  emailsPath = "${config.xdg.configHome}/emails.json";
  mailDir = "${config.home.homeDirectory}/Documents/Mail";
  emailSecrets = builtins.fromJSON (builtins.readFile emailsPath);
  emailAccounts = builtins.mapAttrs mkEmailAccount emailSecrets;
in
{
  programs = {
    mbsync.enable = true;
    # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.neomutt.enable
    neomutt = {
      enable = true;
      vimKeys = true;
      sort = "reverse-date";
      sidebar.enable = true;
    };
    # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.aerc.enable
    aerc = {
      enable = true;
    };
  };

  sops.secrets = {
    emails = {
      mode = "0400";
      path = emailsPath;
    };
  };

  # https://home-manager.dev/manual/unstable/options.xhtml#opt-accounts.email.accounts
  accounts.email = {
    maildirBasePath = mailDir;
    accounts = emailAccounts;
  };
}
