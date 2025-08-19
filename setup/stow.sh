for dir in ~/.dotfiles/config/*; do
    name="$(basename "$dir")"
    if [ "$name" = "hypr" ]; then
        continue
    fi
    cd $dir && stow --target=$HOME/.config/$name .
done

cp -r ~/.dotfiles/config/hypr ~/.config/
