{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  builds = pkgs.callPackage ./builds.nix { inherit lib pkgs; };
in
{
  imports = [ inputs.nix4nvchad.homeManagerModules.nvchad ];
  programs.nvchad = {
    enable = true;
    neovim = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    hm-activation = true;
    backup = false;
    extraPackages =
      with pkgs;
      [
        # lua
        stylua
        luajitPackages.luacheck
        # Nix tooling
        nil
        nixd
        nixfmt
        # Shell tooling
        bash-language-server
        shellcheck-minimal
        shfmt
        # Python tooling
        pyright
        ruff
        isort
        # DevOps && CI/CD
        tflint
        terraform-ls
        prettierd
        gitlab-ci-ls
        yaml-language-server
        kube-linter
        docker-compose-language-service
        dockerfile-language-server
        hadolint
        yamllint
        # kics
      ]
      ++ (with builds; [
        dclint
        dockerfmt
      ]);
  };

  # BUG: Strange that doesnt work on empty .md file
  # ohhh because its an Mimetype:   inode/empty
  # move to obsidian
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    icon = "nvim";
    terminal = false;
    exec = "nvim-open %F";
    type = "Application";
    categories = [ "TextEditor" ];
    mimeType = [
      "text/markdown"
      "text/plain"
    ];
  };
  home.packages = [
    (pkgs.writeShellScriptBin "nvim-open" ''
      SOCKET="/tmp/nvim-server.sock"
      if [ -S "$SOCKET" ]; then
        nvim --server "$SOCKET" --remote "$1"
      else
        kitty -d "''${1%/*}" -o font_size=8 -e nvim --listen "$SOCKET" "$1"
      fi
    '')
  ];
}
