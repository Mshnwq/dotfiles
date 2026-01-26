# programs/email.nix
# accounts?
# https://home-manager.dev/manual/unstable/options.xhtml
{ ... }:
{
  programs.neomutt = {
    enable = true;
  };
  programs.aerc = {
    enable = true;
  };
}
