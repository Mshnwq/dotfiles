# programs/infra.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
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
      "veracrypt"
    ];
  home.packages = with pkgs; [
    kubectl
    kubectx
    k9s
    podman-compose
    lazydocker
    virt-manager
    #ktailctl  # needs nixGL wrap # broken on nvidia,  moved to flatpak
    # veracrypt
  ];
  # https://github.com/hashicorp/terraform/issues/15389
  home.sessionVariables = {
    KUBECONFIG = "${config.xdg.configHome}/kube";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    # https://github.com/sigstore/cosign/commit/32a2d62a9992b1b990f3747e0bbb1533529d7e14
    TUF_ROOT = "${config.xdg.dataHome}/sigstore/root";
    # DOCKER_HOST = unix://$XDG_RUNTIME_DIR/podman/podman.sock;
    # AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
    # https://github.com/gravitational/teleport/issues/7222
  };
}
