{
  description = "Home Manager configuration of mshnwq";

  nixConfig = {
    # https://wiki.hypr.land/Nix/Cachix/
    extra-substituters = [
      # "https://hyprland.cachix.org"
      # "https://yazi.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-substituters = [
      # "https://hyprland.cachix.org"
      # "https://yazi.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    trusted-users = [ "root" "@wheel" ];
    allowed-users = [ "@wheel" ];
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
    let 
      inherit (self) lib;
    in {
    lib = nixpkgs.lib.extend (nixpkgs.lib.composeManyExtensions [
      inputs.bird-nix-lib.lib.overlay
    ]);
    homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          inputs.nixgl.overlay
          inputs.nur.overlays.default
        ];
      };
      modules = [ 
        ./home.nix
        ./yazi.nix
        ./rust.nix
        ./tmux.nix
        ./shell.nix
        ./hypr.nix
        ./auto.nix
        ./pass.nix
        ./infra.nix
        ./music.nix
        ./pywal.nix
        ./mime.nix
        ./flat.nix
        ./nvim.nix
        ({config, pkgs, ...}: {
          imports = [
            (import ./user.nix {
              inherit self config lib inputs pkgs;
            })
          ];
        })
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
