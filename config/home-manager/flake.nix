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
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nixgl.url = "github:nix-community/nixGL";
    nur.url = "github:nix-community/NUR";
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD"";
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
