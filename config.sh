#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	return 1
fi

if [ "$CONFIG_DEBUG" = "FULL" ]; then
	case $- in
	*x*) ;;
	*)
		set -x
		config_xtrace_reset=True
		;;
	esac
fi

. "$CONFIG_DIR/utils/config.sh"
. "$CONFIG_DIR/utils/log.sh"

read_config_file
return_value=$?

if [ "$config_xtrace_reset" = True ]; then
	set +x
fi

return $return_value
