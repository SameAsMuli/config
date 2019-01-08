if [ -z "$CUSTOM_REFS_DIR" ]
then
  if [ -z "$CUSTOM_CONFIG_DIR" ]
  then
    CUSTOM_REFS_DIR=$HOME
  else
    CUSTOM_REFS_DIR=$CUSTOM_CONFIG_DIR
  fi
fi

if [ ! -d "$CUSTOM_REFS_DIR" ]
then
  mkdir -p $CUSTOM_REFS_DIR
fi

export NOTE_FILE=$CUSTOM_REFS_DIR/note

function note() {
  if [ -z $NOTE_FILE ]
  then
    echo "Error: Variable NOTE_FILE not defined..."
    return 1
  fi

  # Decide the editor to use
  if [ -z "$EDITOR" ]
  then
    # TODO Check which editors are installed
    EDITOR=vi
  fi

  if [ $# -eq 0 ]
  then
    $EDITOR $NOTE_FILE
  elif [[ $1 == "--help" ]]
  then
    echo "note [OPTION] [FILE]"
  elif [[ $1 == "-r" || $1 == "--rm" || $1 == "--remove" ]]
  then
    if [ $# -lt 2 ]
    then
      echo "Error: No notes file given to remove"
      return 1
    fi

    for ((i=2;i<=$#;i++))
    do
      if [ ! -f $NOTE_FILE-${!i} ]
      then
        echo "Error: No such notes file '${!i}'"
        return 1
      else
        command rm $NOTE_FILE-${!i}
      fi
    done
  elif [[ $1 == "--list" ]]
  then
    if [[ `ls $NOTE_FILE-* 2> /dev/null | wc -l` == 0 ]]
    then
      echo "No additional notes files"
    else
      echo "Existing notes files:"
      ls $NOTE_FILE-* | sed 's/.*-/  /'
    fi
  elif [[ $1 =~ "-" ]]
  then
    echo "Unknown option: $1"
    return 1
  else
    $EDITOR $NOTE_FILE-$1
  fi
}

alias notes='note'
