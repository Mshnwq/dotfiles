# programs/infra.nix
{
  inputs,
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
  system = pkgs.system;
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
  };
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "veracrypt"
    ];
  home.packages =
    with pkgs;
    [
      podman-compose
      lazydocker
      # veracrypt
    ]
    ++ (with pkgs-stable; [
      kubectl
      kubectx
      k9s
    ]);
  home.sessionVariables = {
    # AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
    KUBECONFIG = "${config.xdg.configHome}/kube";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    TUF_ROOT = "${config.xdg.dataHome}/sigstore/root";
    # https://github.com/hashicorp/terraform/issues/15389
    # https://github.com/gravitational/teleport/issues/7222
    # DOCKER_HOST = unix://$XDG_RUNTIME_DIR/podman/podman.sock;
    # https://github.com/sigstore/cosign/commit/32a2d62a9992b1b990f3747e0bbb1533529d7e14
  };
  home.file."${config.xdg.configHome}/k9s/aliases.yaml" = {
    force = true;
    text = ''
      aliases:
        jo: jobs
        ro: roles
        dp: deployments
        sec: v1/secrets
        rb: rolebindings
        cr: clusterroles
        np: networkpolicies
        crb: clusterrolebindings
    '';
  };
  home.file."${config.xdg.configHome}/k9s/config.yaml" = {
    force = true;
    text = ''
      k9s:
        refreshRate: 2
        maxConnRetry: 5
        readOnly: false
        noExitOnCtrlC: false
        apiServerTimeout: 15s
        liveViewAutoRefresh: false
        portForwardAddress: localhost
        screenDumpDir: ${config.xdg.stateHome}/k9s/screen-dumps
        ui:
          skin: pywal
          noIcons: true
          headless: false
          logoless: false
          reactive: false
          crumbsless: true
          splashless: true
          enableMouse: true
          useFullGVRTitle: false
          defaultsToFullScreen: false
        skipLatestRevCheck: false
        disablePodCounting: false
        shellPod:
          image: busybox:1.35.0
          namespace: default
          limits:
            memory: 100Mi
            cpu: 100m
        imageScans:
          enable: false
          exclusions:
            labels: {}
            namespaces: []
        logger:
          tail: 100
          buffer: 5000
          showTime: false
          textWrap: false
          sinceSeconds: -1
          disableAutoscroll: false
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
