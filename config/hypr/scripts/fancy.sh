#!/usr/bin/env bash

_toggle() { hyprctl eval "hl.config({$1})"; }
_toggle "decoration={blur={enabled=${1##--}}}"
_toggle "animations={enabled=${1##--}}"
