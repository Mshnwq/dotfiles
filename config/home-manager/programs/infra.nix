{
  config,
  pkgs,
  lib,
  ...
}:
let
  # TODO: migrate to devenv modulized monorepo opentofu
  terraform = pkgs.terraform.overrideAttrs (old: {
    meta = old.meta // {
      license = lib.licenses.unfree;
    };
  });
  # TODO: what to do?
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
    kubectx
    k9s
    velero
    rclone
    virt-manager
    podman-compose
    lazydocker
    #pkgs.ktailctl  # needs nixGL wrap # broken on nvidia,  moved to flatpak
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
