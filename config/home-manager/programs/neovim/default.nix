{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  builds = pkgs.callPackage ./builds.nix { inherit lib pkgs; };
  # add this patch to publicize codelens Provider
  patched-neovim =
    inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (oa: {
        preConfigure = oa.preConfigure + ''
          substituteInPlace runtime/lua/vim/lsp/codelens.lua \
            --replace-fail 'return M' $'M._Provider = Provider\nreturn M'
        '';
      });
in
{
  imports = [ inputs.nix4nvchad.homeManagerModules.nvchad ];
  programs.nvchad = {
    enable = true;
    neovim = patched-neovim;
    # neovim = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    hm-activation = true;
    backup = false;
    extraPackages =
      with pkgs;
      [
        # Lua
        stylua
        luajitPackages.luacheck
        # Markdown
        markdown-oxide
        doctoc
        rumdl
        # Nix
        nil
        nixd
        nixfmt
        # Shell
        bash-language-server
        shellcheck-minimal
        shfmt
        # Python
        pyright
        ruff
        isort
        # DevOps
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
}
