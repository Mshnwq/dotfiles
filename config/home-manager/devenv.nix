{ ... }:
{
  git-hooks.hooks = {
    nixfmt-rfc-style = {
      enable = true;
      settings = {
        width = 80;
      };
    };
  };
}
