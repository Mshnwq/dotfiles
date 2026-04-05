{
  lib,
  ...
}:
let
  mkParams = lib.mapAttrsToList lib.nameValuePair;
in
{
  nixpkgs = {
    name = "Nixpkgs (unstable)";
    icon = "https://nixos.org/favicon.ico";
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = mkParams {
          channel = "unstable";
          query = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@pkg"
    ];
  };

  home-manager = {
    name = "Home Manager (master)";
    icon = "https://home-manager.dev/favicon.ico";
    urls = [
      {
        template = "https://home-manager-options.extranix.com";
        params = mkParams {
          release = "master";
          query = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@hm"
    ];
  };

  # noogle = {
  #   name = "Noogle - Nixpkgs Functions";
  #   # The Noogle favicon is just the Nix logo, but lower quality.
  #   # icon = "https://noogle.dev/favicon.png";
  #   icon = "https://nixos.org/favicon.ico";
  #   urls = [
  #     {
  #       template = "https://noogle.dev/q";
  #       params = mkParams { term = "{searchTerms}"; };
  #     }
  #   ];
  #   definedAliases = [
  #     "@ngl"
  #     "@noogle"
  #   ];
  # };

  nix = {
    name = "MyNixos";
    icon = "https://mynixos.com/favicon.ico";
    urls = [
      {
        template = "https://mynixos.com/search";
        params = mkParams {
          q = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@nx"
    ];
  };

  arch = {
    name = "Arch Wiki";
    icon = "https://archlinux.org/favicon.ico";
    urls = [
      {
        template = "https://wiki.archlinux.org/index.php";
        params = mkParams {
          search = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@aw"
    ];
  };

  kube = {
    name = "Kubernetes Wiki";
    icon = "https://kubernetes.io/icons/favicon-16.png";
    urls = [
      {
        template = "https://kubernetes.io/search";
        params = mkParams {
          q = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@kube"
      "@k8"
    ];
  };

  metallum = {
    name = "Metal Encyclopedia";
    icon = "https://www.metal-archives.com/favicon.ico";
    urls = [
      {
        template = "https://www.metal-archives.com/search";
        params = mkParams {
          searchString = "{searchTerms}";
          type = "band_name";
        };
      }
    ];
    definedAliases = [
      "@mt"
      "@ml"
    ];
  };

  songsterr = {
    name = "Songsterr";
    icon = "https://songsterr.com/favicon.ico";
    urls = [
      {
        template = "https://songsterr.com/";
        params = mkParams {
          pattern = "{searchTerms}";
        };
      }
    ];
    definedAliases = [
      "@sg"
    ];
  };
}
