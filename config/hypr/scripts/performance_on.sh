sed -i "$HOME/.config/hypr/conf.d/general.conf" \
	-e "/#-toggle-blur/s/.*#-/	enabled = false \t#-/" \
	-e "/#-toggle-animation/s/.*#-/    enabled = false \t#-/" \
	-e "/#-toggle-ws-animation/s/.*#-/    workspace_wraparound = false \t#-/" \
	-e "/^windowrule = opacity 0.8 override 1 override 1 override, class:firefox.*/ s/^/#/"
