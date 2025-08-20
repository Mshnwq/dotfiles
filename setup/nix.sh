# NIX for version 42
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm --persistence=/var/lib/nix \
  --extra-conf "trusted-users = root @wheel" \
  --extra-conf "extra-substituters = https://hyprland.cachix.org" \
  --extra-conf "extra-trusted-substituters = https://hyprland.cachix.org" \
  --extra-conf "extra-trusted-public-keys = hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
#
# https://github.com/NixOS/nix/issues/1079
# --extra-conf="use-xdg-base-directories = true"
#
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager -- init --switch ~/.config/home-manager --impure

if [ -x "$HOME/.nix-profile/bin/zsh" ]; then
    sudo usermod --shell "$HOME/.nix-profile/bin/zsh" "$USER"
else
    echo "Shell $HOME/.nix-profile/bin/zsh does not exist."
fi
