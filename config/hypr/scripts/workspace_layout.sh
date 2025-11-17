 [[ $(hyprctl activeworkspace -j | jq '.windows') -gt 1 ]] && hyprctl dispatch layoutmsg "setlayout $1"
