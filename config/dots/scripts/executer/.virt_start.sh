#!/usr/bin/env bash
sudo systemctl start libvirtd.service
for drv in log lock qemu interface network nodedev nwfilter secret storage; do
    sudo systemctl start virt${drv}d.service;
    sudo systemctl start virt${drv}d{,-ro,-admin}.socket;
done
sudo virsh net-start default
