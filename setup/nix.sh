# NIX for version 42
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm --persistence=/var/lib/nix
#
# https://github.com/NixOS/nix/issues/1079
# --extra-conf="use-xdg-base-directories = true"
#
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager -- init --switch ~/.config/home-manager --impure
sudo usermod --shell $HOME/.nix-profile/bin/zsh $USER
