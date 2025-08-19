for dir in ~/.dotfiles/config/*; do
    name="$(basename "$dir")"
    mkdir -p "$HOME/.config/$name"
    cd "$dir" && stow --target="$HOME/.config/$name" .
done
