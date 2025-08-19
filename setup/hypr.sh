mkdir -p ~/.build
for i in {1..3}; do
  git clone https://github.com/Mauitron/NiflVeil.git ~/.build/NiflVeil && break
  rm -rf ~/.build/NiflVeil
  sleep 3
done
cd ~/.build/NiflVeil/niflveil || exit
sed -i '341c\        println!("{{\\"text\\":\\" \\",\\"class\\":\\"empty\\",\\"tooltip\\":\\"No minimized windows\\"}}");' src/main.rs
# to make sure cargo in path
. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh 
cargo build --release -j 2
cp target/release/niflveil ~/.local/bin/

# cp -r /mnt/shared/hypr ~/.config/
# hyprctl reload
# TODO: 
# https://github.com/hyprwm/hyprland-plugins
# https://github.com/zakk4223/hyprWorkspaceLayouts
# hyprpm add https://github.com/zakk4223/hyprWorkspaceLayouts
# hyprpm enable hyprWorkspaceLayouts
