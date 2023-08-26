#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
  >&2 echo "$0: \$CONFIG_DIR not defined"
  exit 1
fi

. "$CONFIG_DIR"/utils/log.sh

# Provide default values if necessary
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-"/etc/xdg"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-"/usr/local/share:/usr/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME/.local/state"}"

check_xdg_runtime_dir() {
  if [ -z "$XDG_RUNTIME_DIR" ]; then
    err "\$XDG_RUNTIME_DIR is not set"
  fi

  if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    err "XDG_RUNTIME_DIR '$XDG_RUNTIME_DIR' does not exist"
  fi

  if [ -z "$(find "$XDG_RUNTIME_DIR" -user "$(id -u)" -maxdepth 0 2> /dev/null)" ]
  then
    err "XDG_RUNTIME_DIR '$XDG_RUNTIME_DIR' not owned by current user"
  fi

  # For portability, use `ls` instead of `stat`
  if [ "$(find "$XDG_RUNTIME_DIR" -maxdepth 0 -ls | awk '{print $3}')" != "drwx------" ]; then
    err "XDG_RUNTIME_DIR '$XDG_RUNTIME_DIR' does not have access mode 0700"
  fi
}
