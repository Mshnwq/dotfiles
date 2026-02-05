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
    # // {
    #   "Primary" = {
    #     primary = true;
    #     realName = "";
    #     address = "";
    #     userName = "";
    #     imap = {
    #       host = "127.0.0.1";
    #       port = 1143;
    #       tls.enable = false;
    #     };
    #     smtp = {
    #       host = "127.0.0.1";
    #       port = 1025;
    #       tls.enable = false;
    #     };
    #     mbsync = {
    #       enable = true;
    #       create = "maildir";
    #       patterns = [ "*" ];
    #     };
    #     passwordCommand = "";
    #     aerc.enable = true;
    #   };
    # };
  };
  # home.packages = [
  #   pkgs.hydroxide
  #   pkgs.protonmail-bridge
  # ];

  programs = {
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
        ui = {
          mouse-enabled = true;
        };
        filters = {
          "text/plain" = "less -Rc";
          # "text/html" = "w3m";
          # # Filters allow you to pipe an email body through a shell command to render
          # # certain emails differently, e.g. highlighting them with ANSI escape codes.
          # #
          # # The first filter which matches the email's mimetype will be used, so order
          # # them from most to least specific.
          # #
          # # You can also match on non-mimetypes, by prefixing with the header to match
          # # against (non-case-sensitive) and a comma, e.g. subject,text will match a
          # # subject which contains "text". Use header,~regex to match against a regex.
          # subject,~^\[PATCH=awk -f /etc/nixos/config/aerc/filters/hldiff
          # #text/html=/usr/local/Cellar/aerc/0.5.2/share/aerc/filters/html
          # text/*=awk -f /etc/nixos/config/aerc/filters/plaintext
          # #image/*=catimg -w $(tput cols) -
          # [templates]
          # # Templates are used to populate email bodies automatically.
          # #
          #
          # # The directories where the templates are stored. It takes a colon-separated
          # # list of directories.
          # #
          # # default: /usr/local/Cellar/aerc/0.5.2/share/aerc/templates/
          # template-dirs=/etc/nixos/config/aerc/templates/
        };
      };
    };
  };
}
