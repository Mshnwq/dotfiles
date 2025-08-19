#!/bin/bash

pgrep -f libinput-gestures || { libinput-gestures -c "$HOME/.config/dots/config/libinput-gestures.conf" & }
