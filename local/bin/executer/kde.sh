#!/usr/bin/env bash

case $1 in
--connect)
  sudo firewall-cmd --add-port=1714-1764/udp
  sudo firewall-cmd --add-port=1714-1764/tcp
  kdeconnect-settings
  ;;
--disconnect)
  sudo firewall-cmd --remove-port=1714-1764/udp --permanent
  sudo firewall-cmd --remove-port=1714-1764/tcp --permanent
  pkill kdeconnectd
  sudo firewall-cmd --reload
  ;;
esac
