
https://rpmfusion.org/Howto/OSTree
https://docs.bazzite.gg/Installing_and_Managing_Software/rpm-ostree/

https://docs.getaurora.dev/guides/alternate-install-guide/
Rebasing from another Universal Blue Image (e.g. Bazzite)

If you want to rebase from a Bazzite-KDE Installation to Aurora, you can just skip steps 1-3 and grab a command with your desired image from step 4, from the installation guide above.

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




<!-- https://docs.bazzite.gg/Installing_and_Managing_Software/ -->
Package formats ranked from most recommended to least recommended for daily usage:¶

    ujust (Convenience Commands) - Custom scripts maintained by Bazzite & Universal Blue contributors that can also install a small subset of applications.
    Flatpak (Graphical Applications) - Universal package format using a permissions-based model and should be used for most graphical applications.
    Homebrew (Command-Line Tools) - Install applications intended to run inside of the terminal (CLI/TUI).
    Quadlet (Services) - Run containerized applications as a systemd service.
    Distrobox Containers (Linux Packages & Development Workflows) - Access to most Linux package managers for software that do not support Flatpak and Homebrew and for use as development boxes.
    AppImage (Portable Graphical Applications) - Portable universal package format that relies on specific host libraries at a system-level, usually obtained from a project's website.
    rpm-ostree (System-Level Packages) - Layer Fedora packages at a system-level (not recommended, use as a last resort)
