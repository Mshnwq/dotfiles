#!/usr/bin/env bash

sudo firewall-cmd --remove-port=1714-1764/udp --permanent
sudo firewall-cmd --remove-port=1714-1764/tcp --permanent
pkill kdeconnectd
sudo firewall-cmd --reload
