for dir in ~/.dotfiles/config/*; do
    name="$(basename "$dir")"
    if [ "$name" = "home-manager" ]; then
        continue
    fi
    mkdir -p "$HOME/.config/$name"
    cd "$dir" && stow --target="$HOME/.config/$name" .
done

# idk why doesn't like stow
cp -r "$HOME/.dotfiles/config/home-manager" "$HOME/.config/"
