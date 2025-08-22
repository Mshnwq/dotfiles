# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}
# myIP address
function myip() {
	ifconfig lo | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig lo | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "lo (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig eth0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "eth0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig eth0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "eth0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}
# get date
function today()
{
    echo Today is `date +"%A %d in %B of %Y (%r)"` return
}
# file into clipboard Xorg
function xcat() {
    cat "$1" | xsel -ib
}
# file into clipboard Wayland
function wcat() {
    cat "$1" | wl-copy
}

# flutter watch
function fltw() {
  tmux send-keys "flutter run $1 $2 $3 $4 --pid-file=/tmp/tf1.pid" Enter \;\
  split-window -v \;\
  send-keys 'npx -y nodemon -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter \;\
  resize-pane -y 5 -t 1 \;\
  select-pane -t 0 \;
}
function show_colour() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}


# Function to convert hex color to RGB byte values
function hex_to_rgb() {
  local hex_color="$1"
  
  # Extract the red, green, and blue components from the hex string
  local red_hex="${hex_color:0:2}"
  local green_hex="${hex_color:2:2}"
  local blue_hex="${hex_color:4:2}"
  
  # Convert the hex components to decimal (byte values 0-255)
  local red_byte=$((16#${red_hex}))
  local green_byte=$((16#${green_hex}))
  local blue_byte=$((16#${blue_hex}))
  
  # Return the RGB values
  echo "$red_byte,$green_byte,$blue_byte"
}

# Function to echo text in the given hex color
function echo_in_color() {
  local hex_color="$1"
  local text="$2"
  
  # Convert hex to RGB byte values
  IFS=',' read -r red green blue <<< $(hex_to_rgb "$hex_color")
  
  # Use ANSI escape code for 24-bit color
  echo -e "\033[38;2;${red};${green};${blue}m$text\033[0m"
}

function gitd() {
  eval $(ssh-agent)
  $HOME/.config/zsh/scripts/add_ssh.expect "$(pass show mshnwq/github-ssh-pass)"
}
