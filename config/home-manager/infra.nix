{ config, pkgs, lib, ... }:
let
  terraform = pkgs.terraform.overrideAttrs
    (old: { meta = old.meta // { license = lib.licenses.unfree; }; });
  veracrypt = pkgs.veracrypt.overrideAttrs
    (old: { meta = old.meta // { license = lib.licenses.unfree; }; });
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "terraform" "veracrypt" ];
  home.packages = [
    pkgs.kubectl
    #pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.velero
    #pkgs.argocd
    #pkgs.rainfrog
    pkgs.rclone
    #pkgs.minio-client
    pkgs.virt-manager
    pkgs.podman-compose
    pkgs.lazydocker
    #pkgs.ktailctl  # needs nixGL wrap # TODO: broken on nvidia # moved to flatpak
    # i have no idea this garbage
    pkgs.nixgl.auto.nixGLDefault # NOTE:run with --impure flag
    pkgs.nixgl.auto.nixGLNvidia # NOTE:run with --impure flag
    pkgs.nixgl.auto.nixGLNvidiaBumblebee # NOTE:run with --impure flag
    pkgs.nixgl.nixGLIntel # NOTE:run with --impure flag
    #pkgs.nixos-anywhere
    veracrypt
    terraform # too SLOW!
  ];
  # https://github.com/hashicorp/terraform/issues/15389
  home.sessionVariables = {
    KUBECONFIG = "${config.xdg.configHome}/kube";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    # DOCKER_HOST = unix://$XDG_RUNTIME_DIR/podman/podman.sock;
    # instead of ~/.mc or ~/.mcli
    # MC_CONFIG_DIR = "${config.xdg.configHome}/minio-client";
    # AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
  };
}
