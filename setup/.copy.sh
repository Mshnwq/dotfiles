for dir in ~/.dotfiles/config/*; do
    name="$(basename "$dir")"
    if [ "$name" = "home-manager" ]; then
        continue
    fi
    cp -r $dir "$HOME/.config/"
done
