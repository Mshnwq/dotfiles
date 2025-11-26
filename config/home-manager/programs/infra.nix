# programs/infra.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
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
  home.file."${config.xdg.configHome}/k9s/aliases.yaml" = {
    force = true;
    text = ''
      aliases:
        dp: deployments
        sec: v1/secrets
        jo: jobs
        cr: clusterroles
        crb: clusterrolebindings
        ro: roles
        rb: rolebindings
        np: networkpolicies
    '';
  };
  home.file."${config.xdg.configHome}/k9s/config.yaml" = {
    force = true;
    text = ''
      k9s:
        liveViewAutoRefresh: false
        screenDumpDir: ${config.xdg.stateHome}/k9s/screen-dumps
        refreshRate: 2
        apiServerTimeout: 15s
        maxConnRetry: 5
        readOnly: false
        noExitOnCtrlC: false
        portForwardAddress: localhost
        ui:
          skin: pywal
          enableMouse: true
          headless: false
          logoless: false
          crumbsless: true
          splashless: true
          reactive: false
          noIcons: true
          defaultsToFullScreen: false
          useFullGVRTitle: false
        skipLatestRevCheck: false
        disablePodCounting: false
        shellPod:
          image: busybox:1.35.0
          namespace: default
          limits:
            cpu: 100m
            memory: 100Mi
        imageScans:
          enable: false
          exclusions:
            namespaces: []
            labels: {}
        logger:
          tail: 100
          buffer: 5000
          sinceSeconds: -1
          textWrap: false
          disableAutoscroll: false
          showTime: false
        thresholds:
          cpu:
            critical: 90
            warn: 70
          memory:
            critical: 90
            warn: 70
        defaultView: ""
    '';
  };
}
