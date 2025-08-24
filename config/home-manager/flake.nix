{
  description = "Home Manager configuration of mshnwq";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD"";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
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
      ];
      # extraSpecialArgs = {
        # yazi = yazi.packages.${pkgs.system}.default;
      # };
    };
  };
}
