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
    if command -v nvim > /dev/null
    then
      EDITOR=nvim
    elif command -v vim > /dev/null
    then
      EDITOR=vim
    elif command -v vi > /dev/null
    then
      EDITOR=vi
    else
      echo "Could not find editor to use"
      return 1
    fi
  fi

  # Set the linebreak option if we're using a vi variant
  if grep -E 'vi |vim |nvim ' <<< "$EDITOR" > /dev/null
  then
    local L_EDITOR="$EDITOR -c \":set linebreak\" -c \":set spell\""
  else
    local L_EDITOR="$EDITOR"
  fi

  if [ $# -eq 0 ]
  then
    eval $L_EDITOR $NOTE_FILE
  elif [[ $1 == "--help" ]]
  then
    echo "note [OPTION] [FILE]"
    echo ""
    echo "  -l, --list    list all notes files"
    echo "  -n, --rename  change the name of a notes file"
    echo "  -r, --remove  delete one or more notes files"
  elif [[ $1 == "-l" || $1 == "--list" ]]
  then
    if [[ `ls $NOTE_FILE-* 2> /dev/null | wc -l` == 0 ]]
    then
      echo "No additional notes files"
    else
      ls $NOTE_FILE-* | sed 's/.*-/  /'
    fi
  elif [[ $1 == "-n" || $1 == "--rename" ]]
  then
    if [ $# -lt 2 ]
    then
      echo "Error: No notes file given to move"
      return 1
    elif [ $# -lt 3 ]
    then
      echo "Error: No new name given for notes file"
      return 1
    elif [ $# -gt 3 ]
    then
      echo "Error: Too many arguments given"
      return 1
    elif [ ! -f $NOTE_FILE-$2 ]
    then
      echo "Error: No such notes file '$2'"
      return 1
    elif [[ $2 == $3 ]]
    then
      echo "Error: cannot rename '$2' to the same name"
      return 1
    elif [ -f $NOTE_FILE-$3 ]
    then
      echo "Error: Notes file '$3' already exists"
      return 1
    else
      mv $NOTE_FILE-$2 $NOTE_FILE-$3
    fi
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
  elif [[ $1 =~ "-" ]]
  then
    echo "Unknown option: $1"
    return 1
  else
    eval $L_EDITOR $NOTE_FILE-$1
  fi
}

_note()
{
  if [ "${#COMP_WORDS[@]}" == "2" ]
  then
    COMPREPLY=($(compgen -W "$(note --list)" -- "${COMP_WORDS[1]}"))
  fi

  if ([ "${COMP_WORDS[1]}" == "-n" ] ||
      [ "${COMP_WORDS[1]}" == "--rename" ]) &&
     ([ "${#COMP_WORDS[@]}" == "3" ])
  then
    COMPREPLY=($(compgen -W "$(note --list)" -- "${COMP_WORDS[2]}"))
  fi

  if ([ "${COMP_WORDS[1]}" == "-r" ] ||
      [ "${COMP_WORDS[1]}" == "--rm" ] ||
      [ "${COMP_WORDS[1]}" == "--remove" ]) &&
     ([ "${#COMP_WORDS[@]}" > "2" ])
  then
    COMPREPLY=($(compgen -W "$(note --list)" -- "${COMP_WORDS[$((${#COMP_WORDS[@]}-1))]}"))
  fi

  return
}

alias notes='note --list'
# complete -F _note note
