RICE="futhark"
echo "$RICE" > ~/.config/dots/.rice

WALL="$HOME/.config/dots/rices/$RICE/walls/glacier.png" 
echo "$WALL" > ~/.config/dots/.rice

~/.config/dots/scripts/WallColor $WALL
