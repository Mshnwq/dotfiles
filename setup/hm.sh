mkdir -p "$HOME/.local/bin"
cp -r "$HOME/.dotfiles/config/home-manager" "$HOME/.config/"
cd ~/.config/home-manager && home-manager switch --impure
