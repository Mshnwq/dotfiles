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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bird-nix-lib.url = "github:spikespaz/bird-nix-lib";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nixgl.url = "github:nix-community/nixGL";
    nur.url = "github:nix-community/NUR";
    devenv.url = "github:cachix/devenv";
    nvchad-starter = {
      url = "github:Mshnwq/nvchad?ref=main";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
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
    in
    {
      lib = nixpkgs.lib.extend (
        nixpkgs.lib.composeManyExtensions [ inputs.bird-nix-lib.lib.overlay ]
      );
      homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            inputs.nixgl.overlay
            inputs.nur.overlays.default
          ];
        };
        modules = [
          (
            { config, pkgs, ... }:
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
