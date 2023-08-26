#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/colour.sh

_log_timestamp() {
	if [ "$CONFIG_DEBUG" = "TRUE" ] || [ "$CONFIG_DEBUG" = "FULL" ]; then
		printf '[%s] ' "$(date +"%H:%M:%S")"
	fi
}

err() {
	_log_timestamp >&2
	echo >&2 "${CLR_ERROR}$*${CLR_RESET}"
}

warn() {
	_log_timestamp >&2
	echo >&2 "${CLR_WARN}$*${CLR_RESET}"
}

success() {
	_log_timestamp
	echo "${CLR_SUCCESS}$*${CLR_RESET}"
}

info() {
	_log_timestamp
	echo "${CLR_INFO}$*${CLR_RESET}"
}

debug() {
	[ -z "$CONFIG_DEBUG" ] && return
	_log_timestamp
	if [ "$CONFIG_DEBUG" = "TRUE" ] || [ "$CONFIG_DEBUG" = "FULL" ]; then
		echo "${CLR_DEBUG}$*${CLR_RESET}"
	fi
}
