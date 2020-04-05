export TODO_SCRIPT="$CUSTOM_CONFIG_COMMANDS_DIR/.todo"
export TODO_FILE="$CUSTOM_REFS_DIR/todo"

if [ -x "$TODO_SCRIPT" ]
then
  alias todo='$TODO_SCRIPT'
else
  unset TODO_FILE
  unset TODO_SCRIPT
fi
