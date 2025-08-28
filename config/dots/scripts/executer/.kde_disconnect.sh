sudo ufw delete allow 1714:1764/udp
sudo ufw delete allow 1714:1764/tcp
# sudo ufw delete allow from 192.168.0.0/24 1714:1764/tcp
# sudo ufw delete allow from 192.168.0.0/24 1714:1764/udp
pkill kdeconnectd
