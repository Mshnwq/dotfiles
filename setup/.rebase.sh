rpm-ostree rebase ostree-image-signed:docker://ghcr.io/mshnwq/mshnwq-atomic-solopasha:latest

# rpm-ostree initramfs-etc --track=/etc/ostree/prepare-root.conf --reboot

sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix:latest
reboot
sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix:latest
ujust install-system-flatpaks
