
https://rpmfusion.org/Howto/OSTree
https://docs.bazzite.gg/Installing_and_Managing_Software/rpm-ostree/

https://docs.getaurora.dev/guides/alternate-install-guide/
Rebasing from another Universal Blue Image (e.g. Bazzite)

If you want to rebase from a Bazzite-KDE Installation to Aurora, you can just skip steps 1-3 and grab a command with your desired image from step 4, from the installation guide above.

NOTE: Do not rebase from a Gnome-based image to Aurora or back!

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
