{
  description = "Home Manager configuration of mshnwq";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bird-nix-lib.url = "github:spikespaz/bird-nix-lib";
    nixgl.url = "github:nix-community/nixGL";
    nur.url = "github:nix-community/NUR";
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD"";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = let
          packageOverlays = import ./packages/overlays.nix nixpkgs.lib;
        in [
          inputs.nixgl.overlay
          inputs.nur.overlays.default
        ] ++ builtins.attrValues packageOverlays;
      };
      modules = [ 
        ./hypr.nix
        ./home.nix
        ./yazi.nix
        ./rust.nix
        ./tmux.nix
        ./auto.nix
        ./pass.nix
        ./infra.nix
        ./music.nix
        ./pywal.nix
        ./shell.nix
        ./wrap.nix
        ./mime.nix
        ./nvim.nix
        ({config, pkgs, ...}: {
          imports = [
            (import ./user.nix {
              inherit config pkgs;
              inherit inputs;
              inherit self;
              lib = nixpkgs.lib.extend (nixpkgs.lib.composeManyExtensions [
                inputs.bird-nix-lib.lib.overlay
                (import ./lib)
              ]);
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
