# programs/obsidian/snippets.nix
{
  pkgs,
  ...
}:
# TODO: find good snippets
# https://prakashjoshipax.com/obsidian-css-snippets/
# also Ctrl + Shift + i | to use console and manually modify
[
  {
    name = "right-ribbon";
    enable = true;
    text = ''
      .workspace-ribbon {
        order: 3;
        position: relative;
      }
      .sidebar-toggle-button {
        display: none;
      }
      .workspace-ribbon.mod-left:before {
        display: none;
      }
    '';
  }
]
