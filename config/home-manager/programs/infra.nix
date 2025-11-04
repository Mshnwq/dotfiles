{
  config,
  pkgs,
  lib,
  ...
}:
let
  terraform = pkgs.terraform.overrideAttrs (old: {
    meta = old.meta // {
      license = lib.licenses.unfree;
    };
  });
  veracrypt = pkgs.veracrypt.overrideAttrs (old: {
    meta = old.meta // {
      license = lib.licenses.unfree;
    };
  });
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "terraform"
      "veracrypt"
    ];
  home.packages = with pkgs; [
    kubectl
    k9s
    velero
    #argocd
    #rainfrog
    rclone
    virt-manager
    podman-compose
    lazydocker
    #pkgs.ktailctl  # needs nixGL wrap # TODO: broken on nvidia # moved to flatpak
    # i have no idea this garbage
    nixgl.auto.nixGLDefault # NOTE:run with --impure flag
    nixgl.auto.nixGLNvidia # NOTE:run with --impure flag
    nixgl.auto.nixGLNvidiaBumblebee # NOTE:run with --impure flag
    nixgl.nixGLIntel # NOTE:run with --impure flag
    #nixos-anywhere
    veracrypt
    terraform # too SLOW!
  ];
  # https://github.com/hashicorp/terraform/issues/15389
  home.sessionVariables = {
    KUBECONFIG = "${config.xdg.configHome}/kube";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    # DOCKER_HOST = unix://$XDG_RUNTIME_DIR/podman/podman.sock;
    # AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
  };
}
