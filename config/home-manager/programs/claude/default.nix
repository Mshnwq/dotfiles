# programs/claude/default.nix
{
  config,
  pkgs,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
    # settings = {
    #   theme = "dark-ansi";
    # };
  };
  home.packages = with pkgs; [
    # TODO: find way to work with keyring (KWallet not gnome-keyring)
    claude-desktop # from /overlays
    claude-monitor # https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor
    # fff-mcp # from /pkgs
    # openclaw # needs sandboxing https://buduroiu.com/blog/openclaw-microvm/
  ];
  programs.which-key = {
    entries = [
      {
        key = "c";
        desc = "Claude";
        cmd = "claude-desktop";
      }
    ];
  };
}
