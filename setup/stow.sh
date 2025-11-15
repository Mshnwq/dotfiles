#!/usr/bin/env bash
for dir in ~/.dotfiles/config/*; do
  name="$(basename "$dir")"
  mkdir -p "$HOME/.config/$name"
  if [ "$name" = "dots" ]; then
    mkdir -p "$HOME/.config/$name/config"
    cp -r "$dir/config/assets" "$HOME/.config/$name/config"
    cd "$dir" && stow --target="$HOME/.config/$name" --ignore='assets' .
    continue
  fi
  cd "$dir" && stow --target="$HOME/.config/$name" .
done

for dir in ~/.dotfiles/local/*; do
  name="$(basename "$dir")"
  mkdir -p "$HOME/.local/$name"
  cd "$dir" && stow --target="$HOME/.local/$name" .
done
