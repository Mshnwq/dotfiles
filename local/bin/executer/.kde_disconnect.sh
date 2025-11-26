sudo firewall-cmd --remove-port=1714-1764/udp --permanent
sudo firewall-cmd --remove-port=1714-1764/tcp --permanent
pkill kdeconnectd
sudo firewall-cmd --reload
# sudo ufw delete allow 1714:1764/udp
# sudo ufw delete allow 1714:1764/tcp
# sudo ufw delete allow from 192.168.0.0/24 1714:1764/tcp
# sudo ufw delete allow from 192.168.0.0/24 1714:1764/udp
