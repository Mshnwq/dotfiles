#!/usr/bin/env bash
(($(hyprctl activeworkspace -j | jq '.windows') > 1)) && hyprctl dispatch layoutmsg "setlayout $1"
