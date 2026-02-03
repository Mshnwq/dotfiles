# programs/email.nix
{
  pkgs,
  config,
  ...
}:
let
  mailDir = "${config.home.homeDirectory}/Documents/Mail";
in
{
  # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.neomutt.enable
  programs = {
    mbsync.enable = true;
    neomutt = {
      enable = true;
      vimKeys = true;
      sort = "reverse-date";
      sidebar.enable = true;
    };
  };

  # https://home-manager.dev/manual/unstable/options.xhtml#opt-accounts.email.accounts
  accounts.email = {
    maildirBasePath = mailDir;
    accounts = {
      "" = {
        realName = "";
        signature = {
          showSignature = "append";
          text = "";
        };
        address = "";
        userName = "";
        imap = {
          host = "";
          port = ;
        };
        smtp = {
          host = "";
          port = ;
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
        passwordCommand = "";
      };
      "" = {
        realName = "";
        signature = {
          showSignature = "append";
          text = "";
        };
        address = "";
        userName = "";
        imap = {
          host = "";
          port = ;
        };
        smtp = {
          host = "";
          port = ;
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
        passwordCommand = "";
      };
    };
  };

  # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.aerc.enable
  # programs.aerc = {
  #   enable = true;
  # };
}
