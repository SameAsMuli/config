#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/log.sh
. "$CONFIG_DIR"/utils/xdg.sh

install_dir="$XDG_CONFIG_HOME/nvim"

set -e

if [ -d "$install_dir" ]; then
	old_dir="${install_dir}.old"
	warn "$install_dir: already exists - moving to '$old_dir'"
	if [ -d "$old_dir" ]; then
		err "$old_dir: already exists"
		exit 1
	fi
	mv "$install_dir" "$old_dir"
fi

git clone https://github.com/SameAsMuli/config-nvim/ "$install_dir"
