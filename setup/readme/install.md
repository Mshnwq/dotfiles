lol: https://github.com/ublue-os/main/issues/765

# 1: install Fedora Atomic Kinoite iso (KDE spin)

# flash
dd bs=4M if=./Fedora-Kinoite-ostree-x86_64-43-1.6.iso of=/dev/sdx conv=fsync oflag=direct status=progress

# read partition.md

# https://docs.getaurora.dev/guides/alternate-install-guide/
Do not create a root user.
# 2: Rebase to Bazzite custom image

# FOR AMD do this
sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix:latest
reboot
sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix:latest

# FOR NVIDIA NEW do this
sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia-open:latest
reboot
sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia-open:latest

# FOR NVIDIA OLD do this
sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia:latest
reboot
sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia:latest

# NOTE: Do not rebase from a Gnome-based image to Aurora or back!

ujust toggle-user-motd
ujust add-user-to-input-group

# 3: ujust commands
ujust install-cpu-governer # migrated to nix?
ujust install-custom-flatpaks
ujust install-nix

# order here is important
ujust install-dotfiles
ujust install-home-manager
ujust install-rice

reboot to Hyprland

# 4: look into /usr/share/ublue-os/just
# https://www.youtube.com/watch?v=dKynTzn1_BY
# https://docs.bazzite.gg/Installing_and_Managing_Software/Waydroid_Setup_Guide/
ujust setup-waydroid
    - initialize waydroid

# NOTE: 
# DO NOT USE /usr/bin/waydroid-launcher!!!

waydroid status
waydroid show-full-ui
waydroid session stop

# needs stop running
#https://github.com/casualsnek/waydroid_script#waydroid-extras-script
ujust setup-waydroid
    - configure waydroid
    > android 13
    > install gapps

# needs to be running
waydroid show-full-ui

ujust setup-waydroid
    - configure waydroid
    > android 13
    > Google Certify

# i need to create special account gmail for this
# then install 
    - authenticators (MICROSOFT, Google) and OPSWAT
    - KDE Connect (configure firewall in scripts)
    - ColorNote (get backup) 

# ujust 84-virt
ujust setup-virtualization
    - add to libvirt group
    - enable, it will install flatpak virt-manager
sudo systemctl disable cups.service
reboot
