#https://github.com/Windows-On-Linux/Guitar-Pro-On-Linux

mkdir -p ~/Documents/Guitar_Pro_8 && cd ~/Documents/Guitar_Pro_8
#cp ~/.dotfiles/setup/guitar/icon.png ~/Documents/Guitar_Pro_8
#cp ~/.dotfiles/setup/guitar/guitarpro.desktop ~/.local/share/applications
echo "Downloading Guitar Pro 8..."
wget https://download-fr-3.guitar-pro.com/gp8/stable/guitar-pro-8-setup.exe
echo "Preparing Wineprefix enviroment..."
