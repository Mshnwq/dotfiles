#!/usr/bin/env bash

DOTDIR=$(<"$HOME/.config/dotdir")
DOTDIR="${DOTDIR/#\~/$HOME}"

for dir in "$DOTDIR"/config/*; do
  name="$(basename "$dir")"
  mkdir -p "$HOME/.config/$name"
  if [ "$name" = "sops" ]; then
    mkdir -p "$HOME/.config/$name"
    cp -r "$dir/age" "$HOME/.config/$name"
    continue
  fi
  if [ "$name" = "dots" ]; then
    mkdir -p "$HOME/.config/$name/rices"
    cp -r "$dir/rices/default" "$HOME/.config/$name/rices"
    cd "$dir" && stow --target="$HOME/.config/$name" .
    continue
  fi
  cd "$dir" && stow --target="$HOME/.config/$name" .
done

for dir in "$DOTDIR"/local/*; do
  name="$(basename "$dir")"
  mkdir -p "$HOME/.local/$name"
  cd "$dir" && stow --target="$HOME/.local/$name" .
done
