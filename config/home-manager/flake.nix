# flake.nix
{
  description = "Mshnwq Home Manager configuration";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    allowed-users = [ "@wheel" ];
  };

  inputs = {
    # systems.url = "github:nix-systems/default";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-fork.url = "github:mshnwq/nixpkgs/66595d469ee964a75e30a08eb9abcaaab4d30a5e";
    nixpkgs.follows = "nixpkgs-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland = {
      url = "github:hyprwm/hyprland/v0.53.1";
    };
    hyprWorkspaceLayouts = {
      url = "github:zakk4223/hyprWorkspaceLayouts/d90c6c3"; # make sure works with hyrpland version
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    bird-nix-lib = {
      url = "github:spikespaz/bird-nix-lib";
    };
    # for mkWine
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # waifu-cursors.url = "github:maotseantonio/waifu-cursors";
    devenv = {
      url = "github:cachix/devenv/v1.10";
    };
    yazi = {
      url = "github:sxyazi/yazi/v26.1.4";
      # url = "github:sxyazi/yazi/v26.1.22 ";
    };
    nvchad-starter = {
      url = "github:Mshnwq/nvchad";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (self) lib;
      inputs' = inputs // {
        useSops = builtins.getEnv "ENABLE_SOPS" == "true";
      };
    in
    {
      lib = nixpkgs.lib.extend (
        nixpkgs.lib.composeManyExtensions (import ./lib/default.nix inputs')
      );

      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            (import ./pkgs/overlays.nix {
              lib = lib;
              inputs = inputs';
            })
          ]
          ++ (import ./overlays/default.nix inputs');
        };
        modules = [
          (
            {
              config,
              pkgs,
              ...
            }:
            {
              imports = [
                (import ./user.nix {
                  inherit
                    self
                    config
                    lib
                    pkgs
                    ;
                  inputs = inputs';
                })
              ];
            }
          )
        ];
        extraSpecialArgs = { inherit inputs'; };
      };
    };
}
