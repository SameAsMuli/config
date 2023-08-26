#!/bin/sh
# shellcheck disable=SC2155

if ! type tput >/dev/null 2>&1; then
	echo >&2 "$0: cannot load colours: tput not found"
	exit 1
fi

export CLR_BLACK="$(tput setaf 0)"
export CLR_RED="$(tput setaf 1)"
export CLR_GREEN="$(tput setaf 2)"
export CLR_YELLOW="$(tput setaf 3)"
export CLR_BLUE="$(tput setaf 4)"
export CLR_MAGENTA="$(tput setaf 5)"
export CLR_CYAN="$(tput setaf 6)"
export CLR_WHITE="$(tput setaf 7)"

export CLR_DEBUG="$CLR_RESET"
export CLR_ERROR="$CLR_RED"
export CLR_INFO="$CLR_BLUE"
export CLR_SUCCESS="$CLR_GREEN"
export CLR_WARN="$CLR_YELLOW"

export CLR_RESET="$(tput sgr0)"
