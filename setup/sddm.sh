sudo mkdir -p /opt
sudo mkdir -p /opt/sddm
sudo mkdir -p /opt/sddm/themes
for i in {1..3}; do
  sudo git clone https://github.com/JaKooLit/simple-sddm-2.git /opt/sddm/themes/simple_sddm_2 --depth=1 && break
  sudo rm -rf /opt/sddm/themes/simple_sddm_2 
  sleep 3
done
sudo sed -i 's/HourFormat="HH:mm"/HourFormat="hh:mm AP"/' "/opt/sddm/themes/simple_sddm_2/theme.conf"
sudo rm -rf /opt/sddm/themes/simple_sddm_2/.git

sudo tee /etc/sddm.conf.d/theme.conf <<'EOL'
[Theme]
ThemeDir=/opt/sddm/themes
Current=simple_sddm_2
EOL
