{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  dockerfmt = pkgs.stdenv.mkDerivation rec {
    pname = "dockerfmt";
    version = "0.3.7";

    src = pkgs.fetchFromGitHub {
      owner = "reteps";
      repo = "dockerfmt";
      rev = "v${version}";
      hash = "sha256-cNxPe0LOZyUxyw43fmTQeoxvXcT9K+not/3SvChBSx4=";
    };

    nativeBuildInputs = [ pkgs.go ];

    buildPhase = ''
      echo "Building dockerfmt..."
      cd $src
      mkdir -p $out/bin
      export CGO_ENABLED=0
      export GOCACHE=$TMPDIR/go-cache
      mkdir -p $GOCACHE
      export GOPATH=$TMPDIR/go
      mkdir -p $GOPATH
      go build -ldflags="-s -w" -o $out/bin/dockerfmt
    '';

    meta = with lib; {
      description = "Dockerfile formatter";
      homepage = "https://github.com/reteps/dockerfmt";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  dclint = pkgs.buildNpmPackage rec {
    pname = "dclint";
    version = "3.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "zavoloklom";
      repo = "docker-compose-linter";
      rev = "v${version}";
      sha256 = "sha256-5nPBWDJGPmPWRyhzSf4WaT8JUqHIOipxO3ATdSRnURA=";
    };

    npmDepsHash = "sha256-NHrVkAX+3VtlSYK83SwMiItoGOl06tEGO6IsI4vNQsM=";

    npmDepsHook = ''
      export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
      export NPM_CONFIG_FETCH_TIMEOUT=1200000
      export NPM_CONFIG_FETCH_RETRIES=10
    '';

    npmBuildScript = "build";

    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.typescript
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/node_modules
      cp -r . $out/lib/node_modules/${pname}

      pushd $out/lib/node_modules/${pname}
        sed -i 's|"outDir": "./dist"|"outDir": "./lib"|' tsconfig.json
        echo "==> Building from vendored deps..."
      popd

      mkdir -p $out/bin
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/dclint \
        --add-flags "$out/lib/node_modules/${pname}/bin/dclint.cjs"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Docker Compose Linter (DCLint) to analyze, validate, and fix Docker Compose files";
      license = licenses.mit;
      homepage = "https://github.com/zavoloklom/docker-compose-linter";
    };
  };
in
{
  imports = [
    inputs.nix4nvchad.homeManagerModules.nvchad
  ];

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;

    extraPackages = with pkgs; [
      # lua
      stylua
      luajitPackages.luacheck

      # Nix tooling
      nil
      nixd
      nixfmt

      # Shell tooling
      bash-language-server
      shellcheck-minimal
      shfmt

      # Python tooling
      pyright
      ruff
      isort

      # DevOps / CI/CD
      tflint
      terraform-ls
      prettierd
      gitlab-ci-ls
      yaml-language-server
      kube-linter
      docker-compose-language-service
      dockerfile-language-server-nodejs
      hadolint

      # TODO / additional tools
      yamllint
      kics

      # Custom packages
      dclint
      dockerfmt
    ];

    extraConfig = '''';
  };
}
