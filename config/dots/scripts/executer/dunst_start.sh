pkill dunst 2>/dev/null || true
nohup dunst -config "$HOME/.config/dots/config/dunstrc" >/dev/null 2>&1 &
