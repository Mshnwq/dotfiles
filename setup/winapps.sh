# TODO: SOPS CONFIG & .ENV
# TODO: needs special ext4 partition, btrfs is no good & fix home mounting
# https://universal-blue.discourse.group/t/winapps-discussion/8161/18
# https://www.answeroverflow.com/m/1307013565714137200

git clone --recurse-submodules --remote-submodules https://github.com/winapps-org/winapps.git ~/.build/winapps
mkdir ~/.config/winapps/
touch ~/.config/winapps/winapps.conf
# Set RDP_USER and RDP_PASS to what you want your Windows user account login to be.
# Set WAFLAVOR="podman".

cd ~/.build/winapps || exit

# https://universal-blue.discourse.group/t/winapps-in-bazzite-portal/2199/3

# Now we need to modify the compose.yaml file:

# Make sure to set USERNAME & PASSWORD to match what you put in your winapps.conf config’s RDP_USER & RDP_PASS respectively.
# Change image to: docker.io/dockurr/windows. Prevents issues with Podman and default repo.
# By default Tiny11 direct downloads from Archive.org… very slowly. I recommend downloading via torrent and placing the ISO into the winapps folder under isos/tiny11 23H2 x64.iso. I then added - ./isos/tiny11 23H2 x64.iso:/custom.iso as a volume.
# From there follow the steps under the “Installing Windows” heading. (You can skip the cd winapps bit as you should already be in there)
#
#
# podman-compose --file compose.yaml up
# watch the installation in your browser: "http://127.0.0.1:8006/"

# sudo flatpak override --filesystem=home com.freerdp.FreeRDP 
# flatpak run --command=xfreerdp com.freerdp.FreeRDP /u:"$(pass show mshnwq/winapps-user)" /p:"$(pass show mshnwq/winapps-pass)" /v:127.0.0.1 /cert:tofu

# when its finished logout in your Browser and go back to the cloned repo folder
# podman unshare --rootless-netns
# ./setup.sh
