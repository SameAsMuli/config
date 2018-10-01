# Placeholder for something more complex down the line
# For now just create an alias

if [ -z "$CUSTOM_CONFIG_DIR" ]
then
  echo "Error: Variable CUSTOM_CONFIG_DIR not defined..."
  return 1;
elif [ -z "$CUSTOM_REFS_DIR" ]
then
  CUSTOM_REFS_DIR=$CUSTOM_CONFIG_DIR
fi

if [ ! -d "$CUSTOM_REFS_DIR" ]
then
  mkdir -p $CUSTOM_REFS_DIR
fi

NOTE_FILE=$CUSTOM_REFS_DIR/.note

# Decide the editor to use
if [ -z "$EDITOR" ]
then
  # TODO Check which editors are installed
  EDITOR=vi
fi

alias note="$EDITOR $NOTE_FILE"
alias notes="$EDITOR $NOTE_FILE"
