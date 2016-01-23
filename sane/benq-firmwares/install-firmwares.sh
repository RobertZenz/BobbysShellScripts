#!/usr/bin/env sh

# Licensed under Public Domain or CC0

# Partly from here: http://askubuntu.com/questions/68806/how-do-i-get-an-acer-flatbed-scanner-22-working


# The firmware file to install.
firmware="$1"

# The location of the snapscan configuration file.
snapscan_conf="/etc/sane.d/snapscan.conf"

# The location of the sane firmware directory.
target="/usr/share/sane/firmware"

# The full location of the copied firmware file.
target_firmware="$target/$(basename $firmware)"


if [ -z "$firmware" ]; then
	echo "Installs a BenQ firmware file on the system."
	echo ""
	echo "Usage: $(basename "$0") FIRMWARE_FILE_TO_INSTALL"
	exit 22
elif [ ! -f "$firmware" ]; then
	echo "Specified firmware file \"$firmware\" not found."
	exit 22
fi

if [ $(id -u) -ne 0 ]; then
	echo "This script requires root privileges."
	exit 13
fi


# Create the target directory if it does not exist.
if [ ! -d "$target" ]; then
	mkdir -p "$target"
	chmod 755 "$target"
fi

# Copy the firmware file itself.
cp "$firmware" "$target_firmware"
chmod 644 "$target_firmware"

# Add it to the snapscan configuration file.
if ! grep -q "firmware $target_firmware" "$snapscan_conf"; then
	# The line we want does not exist in the file, so let's add it.
	echo "" >> "$snapscan_conf"
	echo "# Automatically added BenQ Firmware." >> "$snapscan_conf"
	echo "firmware $target_firmware" >> "$snapscan_conf"
	echo "" >> "$snapscan_conf"
fi

echo "Firmware file \"$firmware\" has been installed on the system and\
added to the snapscan configuration."

