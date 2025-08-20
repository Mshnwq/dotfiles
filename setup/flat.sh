# flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

flatpak install --system -y app/com.github.tchx84.Flatseal/x86_64/stable
flatpak install --system -y app/org.mozilla.firefox/x86_64/stable
flatpak install --system -y app/io.mpv.Mpv/x86_64/stable
flatpak install --system -y app/io.github.getnf.embellish/x86_64/stable
flatpak install --system -y app/io.podman_desktop.PodmanDesktop
flatpak install --system -y app/io.github.dvlv.boxbuddyrs
