#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	return 1
fi

if [ "$CONFIG_DEBUG" = "FULL" ]; then
	set -x
fi

. "$CONFIG_DIR/utils/config.sh"
. "$CONFIG_DIR/utils/log.sh"

read_config_file || return 1
