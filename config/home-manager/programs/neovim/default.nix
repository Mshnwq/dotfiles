{ inputs, pkgs, lib, ... }:
let builds = pkgs.callPackage ./builds.nix { inherit lib pkgs; };
in {
  imports = [ inputs.nix4nvchad.homeManagerModules.nvchad ];

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;

    extraPackages = with pkgs;
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

        # DevOps / CI/CD
        tflint
        terraform-ls
        prettierd
        gitlab-ci-ls
        yaml-language-server
        kube-linter
        docker-compose-language-service
        dockerfile-language-server-nodejs
        hadolint

        # TODO / additional tools
        yamllint
        kics
      ] ++ (with builds; [ dclint dockerfmt ]);

    extraConfig = "";
  };
}
