#!/usr/bin/env bash

case $1 in
--on) sudo tailscale up --exit-node=admin-connector --accept-routes ;;
--off) sudo tailscale up --exit-node= --accept-routes ;;
esac
