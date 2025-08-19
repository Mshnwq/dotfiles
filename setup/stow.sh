for dir in ~/.dotfiles/config/*; do
    name="$(basename "$dir")"
    if [ "$name" = "hypr" ]; then
        continue
    fi
    mkdir -p "$HOME/.config/$name"
    cd "$dir" && stow --target="$HOME/.config/$name" .
done

cp -r "$HOME/.dotfiles/config/hypr" "$HOME/.config/"
