desktop=$(xdg-user-dir DESKTOP)
mkdir ~/Documents/Guitar_Pro_8
cp ~/.dotfiles/setup/guitar/icon.png ~/Documents/Guitar_Pro_8
cp ~/o_8/guitarpro.desktop $desktop
echo "Downloading Guitar Pro 8..."
wget https://download-fr-3.guitar-pro.com/gp8/stable/guitar-pro-8-setup.exe
echo "Preparing Wineprefix enviroment..."
