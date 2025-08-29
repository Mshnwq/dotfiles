sudo systemctl stop nix-daemon.socket nix-daemon.service
sudo rm -rf /nix/* /etc/nix /var/lib/nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels 

sudo rm -rf ~/.config ~/.local ~/.cache ~/.build ~/.dotfiles /opt/* /usr/local/bin/*

sudo rpm-ostree cleanup -m
sudo rpm-ostree reset
sudo ostree admin cleanup

sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix:latest
# reboot
# sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix:latest
