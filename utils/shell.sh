#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	exit 1
fi

. "$CONFIG_DIR"/utils/log.sh

export bash_config="$HOME/.bashrc"
export zsh_config="$HOME/.zshrc"

export config_files="$bash_config:$zsh_config"

case $SHELL in
*bash)
	export shell_config="$bash_config"
	export shell="bash"
	;;
*zsh)
	export shell_config="$zsh_config"
	export shell="zsh"
	;;
*)
	err "Unknown shell: ${SHELL}"
	;;
esac

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*)
	platform=linux
	;;
Darwin*)
	platform=mac
	;;
CYGWIN*)
	platform=cygwin
	;;
MINGW*)
	platform=minGw
	;;
MSYS_NT*)
	platform=git
	;;
*)
	platform="UNKNOWN:${unameOut}"
	;;
esac
export platform
