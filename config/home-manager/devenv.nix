# https://devenv.sh/basics/
{ ... }: {
  # https://devenv.sh/reference/options/#dotenvenable
  dotenv.enable = true;
  dotenv.disableHint = true;
  git-hooks.hooks = { nixfmt-classic.enable = true; };
}
