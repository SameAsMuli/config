# Provide mercurial-style colouring to the default diff function
function diff()
{
  ARGS=("$@")
  SIZE=${#ARGS[@]}

  if [[ $SIZE -ne 2 ]]
  then
    if [[ $SIZE -lt 2 ]]
    then
      echo "diff: missing operand after 'diff'"

    elif [[ $SIZE -gt 2 ]]
    then
      echo "diff: extra operand '${ARGS[2]}'"
    fi

    echo "diff: Try 'diff --help' for more information"
    return 1
  fi

  command diff -u ${ARGS[0]} ${ARGS[1]} | sed '0,/\(--- .*\)/s//\x1b[1;31m\1/;0,/\(+++ .*\)/s//\x1b[1;32m\1/;s/^-/\x1b[31m-/;s/^+/\x1b[32m+/;s/^@/\x1b[35m@/;s/$/\x1b[0m/' | less -FRSX
}
