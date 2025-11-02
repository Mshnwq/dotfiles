# https://asdf-vm.com/guide/getting-started.html
curl -sL https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz | tar xz -C ~/.local/bin/
mkdir -p ~/.local/share/asdf
export ASDF_DATA_DIR=~/.local/share/asdf
~/.local/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 
~/.local/bin/asdf plugin add golang https://github.com/asdf-community/asdf-golang.git    
~/.local/bin/asdf plugin add python https://github.com/danhper/asdf-python.git
~/.local/bin/asdf install golang latest
~/.local/bin/asdf install golang 1.24.5
# ~/.local/bin/asdf set -u golang 1.24.5
# ~/.local/share/asdf/shims/go telemetry off
# ~/.local/bin/asdf install nodejs latest
# ~/.local/bin/asdf install nodejs 20.18.1
# ~/.local/bin/asdf set python system
# ~/.local/bin/asdf install python $(python3 -V | awk '{print $2}')
# ~/.local/bin/asdf install python 3.10.6
