{
  description = "Home Manager configuration of mshnwq";

  nixConfig = {
    # https://wiki.hypr.land/Nix/Cachix/
    extra-substituters = [
      "https://hyprland.cachix.org"
      # "https://yazi.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://hyprland.cachix.org"
      # "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
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
    nixgl.url = "github:nix-community/nixGL";
    hyprland.url = "github:hyprwm/hyprland";  # Latest commit
    # hyprland.url = "github:hyprwm/hyprland?ref=v0.50.0";  # pin version ! does not build plugin
    # hyprnix.url = "github:hyprland-community/hyprnix";
    # hyprnix.inputs.hyprland.follows = "hyprland";
    # yazi.url = "github:sxyazi/yazi?ref=main&rev=HEAD"";
  };

  outputs = { nixgl, hyprland, nixpkgs, home-manager, ... }: {
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
        # ./auto.nix
        ./pass.nix
        # ./nvim.nix
        # ./infra.nix
        ./music.nix
        ./pywal.nix
        ./shell.nix
      ];
      extraSpecialArgs = {
        inherit hyprland;
        # yazi = yazi.packages.${pkgs.system}.default;
      };
    };
  };
}
