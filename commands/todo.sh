export TODO_SCRIPT="$CUSTOM_CONFIG_COMMANDS_DIR/.todo"
export TODO_FILE="$CUSTOM_REFS_DIR/todo"

_todo()
{
  if [ $COMP_CWORD -eq 1 ]
  then
    WORDLIST="add archive display done edit full help low reject remove search urgent view"
    COMPREPLY=($(compgen -W "$WORDLIST" -- "${COMP_WORDS[1]}"))

  elif [ $COMP_CWORD -eq 2 ]
  then

    if [ "${COMP_WORDS[1]}" == "done" ]
    then
      COMPREPLY=($(compgen -W "`grep -o \" ${COMP_WORDS[2]}\w*\" \"$TODO_FILE\" | sort | uniq`" -- "${COMP_WORDS[2]}"))

    elif [ "${COMP_WORDS[1]}" == "edit" ]
    then
      COMPREPLY=($(compgen -W "`grep -rl \"$TODO_STRING\"`" -- "${COMP_WORDS[2]}"))

    elif [ "${COMP_WORDS[1]}" == "view" ]
    then
      COMPREPLY=($(compgen -W "archive done low normal urgent" -- "${COMP_WORDS[2]}"))
    fi
  fi
}

if [ -x "$TODO_SCRIPT" ]
then
  alias todo='$TODO_SCRIPT'
  complete -F _todo todo
else
  unset -f _todo
  unset TODO_FILE
  unset TODO_SCRIPT
fi
