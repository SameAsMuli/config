#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
	echo >&2 "$0: \$CONFIG_DIR not defined"
	return 1
fi

. "$CONFIG_DIR/utils/log.sh"
. "$CONFIG_DIR/utils/shell.sh"
. "$CONFIG_DIR/utils/string.sh"
. "$CONFIG_DIR/utils/xdg.sh"

# Export global config variables
CONFIG_APP_NAME="config"
export CONFIG_CONFIG_HOME="${CONFIG_CONFIG_HOME:-"$XDG_CONFIG_HOME/$CONFIG_APP_NAME"}"
export CONFIG_STATE_HOME="${CONFIG_STATE_HOME:-"$XDG_STATE_HOME/$CONFIG_APP_NAME"}"
export CONFIG_PROFILE="${CONFIG_PROFILE:-$CONFIG_CONFIG_HOME/profile.md}"

# Local variables
config_installed_dir="$CONFIG_STATE_HOME/installed"
plugin_spec_install=install.sh
plugin_spec_source=source.sh

mkdir -p "$config_installed_dir"

# Get the install directory for a given config
read_config_file() {
	while IFS= read -r line; do
		# Trim leading and trailing whitespace
		trimmed_line=$(trim "$line")

		case "$trimmed_line" in
		-*)
      # Get plugin name
			if [ "$platform" = "mac" ]; then
				plugin_name="$(echo "$trimmed_line" | sed -E 's/-([[:space:]]+)?//g')"
			else
				plugin_name="$(echo "$trimmed_line" | sed 's/-\s\+\?//g')"
			fi
			debug "Reading plugin '$plugin_name'"
      # Find plugin directory
			plugin_dir="$CONFIG_DIR/$plugin_name"
			if [ ! -d "$plugin_dir" ]; then
				if [ -e "$plugin_dir" ]; then
					err "$plugin_dir: exists but is not a directory"
				else
					err "$plugin_dir: no such file or directory"
				fi
				return 1
			fi
      # Run any plugin installation
			plugin_install="$plugin_dir/$plugin_spec_install"
			if [ -e "$plugin_install" ]; then
        plugin_installed="$config_installed_dir/$(replace_all "$plugin_name" "/" "%")"
        if [ -e "$plugin_installed" ]; then
          debug "Plugin already installed"
        else
          info "Running installation script '$plugin_install'"
          if [ ! -x "$plugin_install" ]; then
            err "$plugin_install: not executable"
            return 1
          fi
          if "$plugin_install"; then
            touch "$plugin_installed"
            debug "Successfully installed plugin"
          else
            err "Failed to run installation script"
            return 1
          fi
        fi
			fi
      # Source plugin file
			plugin_source="$plugin_dir/$plugin_spec_source"
			if [ -e "$plugin_source" ]; then
        debug "Sourcing script '$plugin_source'"
				if [ ! -r "$plugin_source" ]; then
					err "$plugin_source: not readable"
          return 1
				fi
        # shellcheck disable=SC1090
        . "$plugin_source"
			fi
			;;

		esac
	done <"$CONFIG_PROFILE"
}
