#!/usr/bin/env sh

# Public Domain or CC0

# This restores the thumbnail border in Caja to the rounded one without
# the shadow.



if [ $(id -u) -ne 0 ]; then
	echo "This script requires root privileges."
	exit 13
fi


# Define our target
target=/usr/share/pixmaps/caja/thumbnail_frame.png

# The location of the old frame to use.
old_frame="thumbnail_frame.png"


if [ ! -f "$old_frame" ]; then
	# We don't have the old frame, let's download it from GitHub and save it
	# in a temporary file.
	old_frame="$(mktemp)"
	
	wget \
		--output-document \
		"$old_frame" \
		"https://raw.github.com/mate-desktop/mate-file-manager/0e004c696b0e68b2cff37a4c3315b022a35eaf43/icons/thumbnail_frame.png"
fi

# Copy the image
cp -f "$old_frame" "$target"

# Make sure the rights are correct
chown root:root "$target"
chmod 644 "$target"

echo "Thumbnail border has been restored, Caja might need to be restarted for it to effect."

