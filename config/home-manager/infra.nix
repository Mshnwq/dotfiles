{ config, pkgs, lib, ... }:
let
  terraform = pkgs.terraform.overrideAttrs (old: {
    meta = old.meta // { license = lib.licenses.unfree; };
  });
  veracrypt = pkgs.veracrypt.overrideAttrs (old: {
    meta = old.meta // { license = lib.licenses.unfree; };
  });
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "terraform"
    "veracrypt"
  ];
  home.packages = [
    veracrypt
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.velero
    pkgs.minio-client
    # terraform  # too SLOW!
  ];
  # https://github.com/hashicorp/terraform/issues/15389
  home.sessionVariables = {
    KUBECONFIG = "${config.xdg.configHome}/kube";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    # instead of ~/.mc or ~/.mcli
    MC_CONFIG_DIR = "${config.xdg.configHome}/minio-client";
    # AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
  };
}
