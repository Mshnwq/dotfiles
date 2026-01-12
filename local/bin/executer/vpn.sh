#!/usr/bin/env bash

case $1 in
--on) tailscale up --exit-node=admin-connector --accept-routes ;;
--off) tailscale up --exit-node= --accept-routes ;;
esac
