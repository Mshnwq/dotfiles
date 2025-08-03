mkdir -p "$HOME/.local/bin"
cp -r "$HOME/.dotfiles/config/home-manager" "$HOME/.config/"
export NIXPKGS_ALLOW_UNFREE=1
cd ~/.config/home-manager && home-manager switch --impure
