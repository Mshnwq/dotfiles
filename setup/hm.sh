#!/usr/bin/env bash
export NIXPKGS_ALLOW_UNFREE=1
export ENABLE_SOPS=true
home-manager switch --impure "$@"
