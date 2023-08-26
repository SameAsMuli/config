#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/arg.sh
. "$CONFIG_DIR"/utils/log.sh

replace_all() {
	check_arg_count 3 $# 3
  echo "$1" | tr "$2" "$3"
}

trim() {
	check_arg_count 1 $# 1
	echo "$1" | awk '{$1=$1};1'
}
