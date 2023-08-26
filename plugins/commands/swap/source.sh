#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/arg.sh
. "$CONFIG_DIR"/utils/log.sh

# Swap two files (acts the same as the `mv` command if one file doesn't exist)
swap() {
	help_text "swap <file1> <file2>" "" "$@"
	check_arg_count 2 $# 2

	if [ -e "$1" ] && [ -e "$2" ]; then
		TMPFILE="$1.tmp.$$"
		mv "$1" "$TMPFILE" && mv "$2" "$1" && mv "$TMPFILE" "$2"
	elif [ -e "$1" ]; then
		mv "$1" "$2"
	elif [ -e "$2" ]; then
		mv "$2" "$1"
	else
		err "swap: \`$1\` and \`$2\` do not exist"
	fi
}
