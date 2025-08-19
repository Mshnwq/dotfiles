{
  description = "Home Manager configuration of mshnwq";
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/hyprland";
    # hyprnix.url = "github:hyprland-community/hyprnix";
    # hyprnix.inputs.hyprland.follows = "hyprland";
    nixgl.url = "github:nix-community/nixGL";
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD"";
  };
  # nixConfig = {
  #   extra-substituters = [ "https://yazi.cachix.org" ];
  #   extra-trusted-public-keys = [
  #     "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
  #   ];
  # };
  outputs = { nixgl, nixpkgs, home-manager, ... }: {
    homeConfigurations."mshnwq" = home-manager.lib.homeManagerConfiguration {
      # pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };
      modules = [ 
        ./home.nix
        ./yazi.nix
        ./rust.nix
        ./tmux.nix
        # ./auto.nix
        ./pass.nix
        # ./nvim.nix
        ./hypr.nix
        # ./infra.nix
        # ./music.nix
        ./pywal.nix
        ./shell.nix
      ];
      # extraSpecialArgs = {
      #   yazi = yazi.packages.${pkgs.system}.default;
      # };
    };
  };
}
