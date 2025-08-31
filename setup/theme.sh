RICE="futhark"
echo "$RICE" > ~/.config/dots/.rice

WALL="$HOME/.config/dots/rices/$RICE/walls/glacier.png" 
echo "$WALL" > ~/.config/dots/rices/.wall

~/.config/dots/scripts/WallColor "$WALL"

# tee -a ~/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent.conf <<EOL
# [Prefrences]
# General\Locale=en
# General\CloseToTrayNotified=true
# General\UseCustomUITheme=true
# General\CustomUIThemePath=${HOME}/.build/qbittorrent/dist/catppuccin-pywal.qbtheme
# EOL
