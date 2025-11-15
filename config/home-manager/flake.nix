# flake.nix
{
  description = "Mshnwq Home Manager configuration";

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
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
    #nixpkgs-fork.url = "github:mshnwq/nixpkgs/66595d469ee964a75e30a08eb9abcaaab4d30a5e";
    nixpkgs.follows = "nixpkgs-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    bird-nix-lib.url = "github:spikespaz/bird-nix-lib";
    # waifu-cursors.url = "github:maotseantonio/waifu-cursors";
    devenv.url = "github:cachix/devenv/v1.10";
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
      # systems,
      ...
    }:
    let
      inherit (self) lib;
    in
    {
      lib = nixpkgs.lib.extend (
        nixpkgs.lib.composeManyExtensions (
          [
            # inputs.bird-nix-lib.lib.overlay
          ]
          ++ (import ./lib/default.nix inputs)
        )
      );

      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            (import ./packages/overlays.nix lib)
          ]
          ++ (import ./overlays/default.nix inputs);
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
                    inputs
                    pkgs
                    ;
                })
              ];
            }
          )
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
