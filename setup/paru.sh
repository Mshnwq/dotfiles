distrobox create -n arch-box --image ghcr.io/ublue-os/arch-distrobox:latest --yes
# distrobox enter --no-tty arch-box -- bash -eux <<'EOF' 2>&1 | systemd-cat -t arch-box
distrobox enter arch-box -- bash -eux <<'EOF'
sudo pacman -Syu --noconfirm --needed base-devel git
mkdir -p ~/.build
for i in {1..3}; do
  git clone https://aur.archlinux.org/paru.git ~/.build/paru && break
  rm -rf ~/.build/paru
  sleep 3
done
cd ~/.build/paru
makepkg -si --noconfirm
EOF
podman stop "$(podman ps -q)"
