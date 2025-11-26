#!/usr/bin/env bash
sudo systemctl stop libvirtd.service
for drv in log lock qemu interface network nodedev nwfilter secret storage; do
    sudo systemctl stop virt${drv}d.service;
    sudo systemctl stop virt${drv}d{,-ro,-admin}.socket;
done
