RICE="futhark"
echo "$RICE" > ~/.config/dots/.rice

WALL="$HOME/.config/dots/rices/$RICE/walls/glacier.png" 
echo "$WALL" > ~/.config/dots/rices/.wall

# INSTALL 
# TODO: automate this 
# Plasma Style: Utterly-Round (follows color scheme)
# utterly-round-plasma-style # manually set
# Window Decorations: Utterly-Round-Dark (also follows color scheme)
# in kde settings 
# Set Application Style to Kvantum if not already
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
pywalfox install
pip install watchdog
~/.config/dots/scripts/WallColor "$WALL"

# tee -a ~/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent.conf <<EOL
# [Prefrences]
# General\Locale=en
# General\CloseToTrayNotified=true
# General\UseCustomUITheme=true
# General\CustomUIThemePath=${HOME}/.build/qbittorrent/dist/catppuccin-pywal.qbtheme
# EOL
