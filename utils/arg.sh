#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/log.sh

check_arg_count() {
	if [ $# != 2 ] && [ $# != 3 ]; then
		err "Logic error: invalid number of arguments passed to check_arg_count"
	fi
	min="$1"
	shift
	arg_count="$1"
	shift
	if [ "$min" -gt "$arg_count" ]; then
		err "Invalid number of arguments (minimum $min, received $arg_count)"
	fi
	if [ $# -gt 2 ]; then
		max="$1"
		shift
		if [ "$max" -lt "$arg_count" ]; then
			err "Invalid number of arguments (maximum $max, received $arg_count)"
		fi
	fi
}

help_text() {
	check_arg_count 3 $#
	help_arg="--help"
	[ "$3" = "$help_arg" ] || return
	[ $# -eq 3 ] || err "Cannot use other arguments with \`$help_arg\`"
	echo "usage: $1"
	[ -n "$3" ] && printf "\n%s\n" "$3"
}
