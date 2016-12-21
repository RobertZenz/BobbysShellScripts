#!/usr/bin/env sh

# Creates a new wine prefix in the current directory complete with
# configuration and some helper scripts.
#
# Public Domain or CC0

# Usage: newPrefix.sh
# Just execute it in the directory in which you want the prefix.


script_start="#!/usr/bin/env sh

export WINEPREFIX=\"\$(dirname \"\$(readlink -f \"\$0\")\")\"
"

_create_script() {
	echo "$2" > "$1"
	chmod u+x "$1"
}


_create_script "cfg.sh" "$script_start
winecfg
"

_create_script "explorer.sh" "$script_start
./run.sh explorer.exe
"

_create_script "run.sh" "$script_start
wine \$*
"

_create_script "tricks.sh" "$script_start
winetricks \$*
"

./tricks.sh settings \
	ddr=opengl \
	fontsmooth=disable \
	glsl=enabled \
	multisampling=enabled \
	remove_mono

./tricks.sh settings \
	sandbox

./cfg.sh

