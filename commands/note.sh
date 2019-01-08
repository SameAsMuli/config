function note() {
  if [ -z "$CUSTOM_CONFIG_DIR" ]
  then
    echo "Error: Variable CUSTOM_CONFIG_DIR not defined..."
    return 1
  elif [ -z "$CUSTOM_REFS_DIR" ]
  then
    CUSTOM_REFS_DIR=$CUSTOM_CONFIG_DIR
  fi

  if [ ! -d "$CUSTOM_REFS_DIR" ]
  then
    mkdir -p $CUSTOM_REFS_DIR
  fi

  export NOTE_FILE=$CUSTOM_REFS_DIR/.note

  # Decide the editor to use
  if [ -z "$EDITOR" ]
  then
    # TODO Check which editors are installed
    EDITOR=vi
  fi

  if [[ $# == 0 ]]
  then
    $EDITOR $NOTE_FILE
  elif [[ $1 == "--help" ]]
  then
    echo "note [--list] [filename]"
  elif [[ $1 == "--list" ]]
  then
    if [[ `ls $CUSTOM_REFS_DIR/.note.* 2> /dev/null | wc -l` == 0 ]]
    then
      echo "No additional notes files"
    else
      echo "Existing notes files:"
      ls $CUSTOM_REFS_DIR/.note.* | sed 's/.*\./  /'
    fi
  elif [[ $1 =~ "-" ]]
  then
    echo "Unknown option: $1"
    return 1
  else
    $EDITOR $NOTE_FILE.$1
  fi
}

alias notes='note'
