#!/usr/bin/env bash

CONF_FILE="$HOME/.config/mpv/mpv.conf"
cat > "$CONF_FILE" <<EOF
osd-level=0
title='\${filename}'
hwdec=vaapi
EOF

#vo=gpu
#gpu-api=vulkan
#hwdec-codecs=all

#vo=gpu-next
#hwdec=d3d11va
#gpu-api=d3d11



#Assuming you have a recent Nvidia gpu of course.
#
#I've only newly come to this and been experiementing with getting nvdec working.
#
#Make sure you're using vulkan or opengl
#
#vo=gpu
#
#gpu-api=vulkan
#
#hwdec-codecs=all
#
#ctrl + h when the video is playing to switch to hardware acceleration
#
#Press the 'i' key to check whether nvdec is being used.
#
#Probably not the "best" way but that's how I managed to get it working so far.
