#!/usr/bin/env bash

sudo firewall-cmd --add-port=1714-1764/udp
sudo firewall-cmd --add-port=1714-1764/tcp
kdeconnect-settings
