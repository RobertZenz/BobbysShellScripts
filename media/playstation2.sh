#!/usr/bin/env sh

# Public Domain or CC0

# Script for capturing a Playstation 2 output via S-Video with
# a Hauppauge USB Live 2 in VLC.

# Playstation 2 is a normal (non-slim) version.
# Hauppauge USB-Live-2 is the capture device
#     Bus 002 Device 009: ID 2040:c200 Hauppauge
# S-Video cable from the Playstation 2 to the USB Live 2

# Note that the video and audio devices may vary for you.



# The device which serves the audio.
audio_device="pulse://alsa_input.3.analog-stereo"

# The device which serves the video.
video_device="v4l2:///dev/video1"


# Brightness is set to 100, otherwise the video is too dark.
# Caching it set to 99, otherwise there is noticeable lag between what
# the PlayStation does and what you see on the screen.
vlc \
	"$video_device" \
	":input-slave=$audio_device" \
	":v4l2-brightness=100" \
	":v4l2-brightness-auto=-1" \
	":v4l2-contrast=60" \
	":live-caching=99" \
	":v4l2-input=1" \
	":v4l2-aspect-ratio=16\:9" \
	--aspect-ratio 16:9 \
	--deinterlace 1 \
	--deinterlace-mode "Discard"

