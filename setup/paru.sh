#!/usr/bin/env bash

distrobox create -n arch-box --image ghcr.io/ublue-os/arch-distrobox:latest --yes
distrobox enter arch-box -- bash -eux <<'EOF'
sudo pacman -Syu --noconfirm --needed base-devel git
BUILDDIR=$(<"$HOME/.config/builddir")
BUILDDIR="${BUILDDIR/#\~/$HOME}"
for i in {1..3}; do
  git clone https://aur.archlinux.org/paru.git $BUILDDIR/paru && break
  rm -rf $BUILDDIR/paru
  sleep 3
done
cd $BUILDDIR/paru
makepkg -si --noconfirm
EOF
podman stop "$(podman ps -q)"
