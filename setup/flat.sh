# mkdir -p ~/.build
# for i in {1..3}; do
#   git clone https://gitlab.com/Oglo12/rebos.git ~/.build/rebos && break
#   rm -rf ~/.build/rebos
#   sleep 3
# done
# cd ~/.build/rebos || exit
# # to make sure cargo in path
# . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh 
# cargo build --release -j 2
# cp target/release/rebos ~/.local/bin/

# flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak remote-modify --enable flathub
