export CUSTOM_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CUSTOM_REFS_DIR="$CUSTOM_CONFIG_DIR/.refs"

if [ ! -d $CUSTOM_REFS_DIR ]
then
  mkdir -p $CUSTOM_REFS_DIR
fi

export CUSTOM_CONFIG_COMMANDS_DIR=$CUSTOM_CONFIG_DIR/commands
if [ -d $CUSTOM_CONFIG_COMMANDS_DIR ]
then
  for file in $(find $CUSTOM_CONFIG_COMMANDS_DIR -type f -not -name "*.md" -not -path '*/\.*')
  do
    source $file
  done
else
  unset CUSTOM_CONFIG_COMMANDS_DIR
fi

export CUSTOM_CONFIG_PACKAGES_DIR=$CUSTOM_CONFIG_DIR/packages
if [ ! -d $CUSTOM_CONFIG_PACKAGES_DIR ]
then
  unset CUSTOM_CONFIG_PACKAGES_DIR
fi

export CUSTOM_CONFIG_TERMINAL_DIR=$CUSTOM_CONFIG_DIR/terminal
if [ -d $CUSTOM_CONFIG_TERMINAL_DIR ]
then
  for file in $(find $CUSTOM_CONFIG_TERMINAL_DIR -type f -not -name "*.md" -not -path '*/\.*')
  do
    source $file
  done
else
  unset CUSTOM_CONFIG_TERMINAL_DIR
fi

export CUSTOM_CONFIG_LOCAL_DIR=$CUSTOM_CONFIG_DIR/local
if [ -d $CUSTOM_CONFIG_LOCAL_DIR ]
then
  for file in $(find $CUSTOM_CONFIG_LOCAL_DIR -type f -not -name "*.md" -not -path '*/\.*')
  do
    source $file
  done
else
  unset CUSTOM_CONFIG_LOCAL_DIR
fi
