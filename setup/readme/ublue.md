
https://rpmfusion.org/Howto/OSTree
https://docs.bazzite.gg/Installing_and_Managing_Software/rpm-ostree/

https://docs.getaurora.dev/guides/alternate-install-guide/
Rebasing from another Universal Blue Image (e.g. Bazzite)

If you want to rebase from a Bazzite-KDE Installation to Aurora, you can just skip steps 1-3 and grab a command with your desired image from step 4, from the installation guide above.

# 1: install fedora atomic kinoite iso (KDE spin)

# 2: rebase to custom image
sudo bootc ghcr.io/mshnwq/bazzite-hyprland-nix:latest
reboot
sudo bootc --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix:latest

or

sudo bootc ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia:latest
reboot
sudo bootc --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix-nvidia:latest

NOTE: Do not rebase from a Gnome-based image to Aurora or back!

# 3: ujust commands
ujust install-cpu-governer
ujust install-custom-flatpaks
ujust install-nix

# order here is important
ujust install-dotfiles
ujust install-home-manager
ujust install-rice

# 4: look into /usr/share/ublue-os/just
# TODO: ujust 82-waydroid BROKEN!!
# https://docs.bazzite.gg/Installing_and_Managing_Software/Waydroid_Setup_Guide/

# ujust 84-virt
add to libvirtgroup
add to input group

Base: 
    bazzite:
        - DE: KDE "main", Gnome
        - DS: KDE  (# NOTE: run this on my pc I guess)
    bluefin: 
        - DE: Gnome
    aurora:
        - DS: KDE  (# NOTE: run this on my laptop I guess)

Hyprland:
    option 1: copr solopasha layer 
    option 2: nix flak

Flatpak: 
    - TODO: i must compare tools

Nix: 
    - rebuild rpm-ostree to be able to /nix
    - reboot
    - install nix determinate
    - initialize home-manager (with hyprland or not)
