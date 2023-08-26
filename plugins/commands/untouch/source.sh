#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/arg.sh
. "$CONFIG_DIR"/utils/log.sh

untouch() {
	help_text "untouch <file>" "Revert modified time on a file to 01/01/1970" "$@"
	check_arg_count 1 $# 1
	[ -f "$1" ] || err "untouch: No such file or directory"
	touch -m -t 7001010100 "$1"
}
