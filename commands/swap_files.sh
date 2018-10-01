# Swap two files
function swap()
{
  ARGS=("$@")
  SIZE=${#ARGS[@]}

  if [[ $SIZE -ne 2 ]]
  then
    if [[ $SIZE -lt 2 ]]
    then
      echo "swap: missing operand after 'swap'"

    elif [[ $SIZE -gt 2 ]]
    then
      echo "swap: extra operand '${ARGS[2]}'"
    fi

    #echo "swap: Try 'swap --help' for more information"
    echo "usage: swap [FILE] [FILE]"
    return 1
  fi

  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}
