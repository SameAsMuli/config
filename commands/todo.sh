##########################################################
##                                                      ##
##                   Made by Sam Amis                   ##
##                                                      ##
##########################################################

function finish {
  echo
  stty echo
  tput cnorm
  rm $TODO
  rm $CHECK
  exit 0
}

function draw_screen {
  clear
  head -n $((`tput lines`-1)) $TODO
}

function todo {
  # Define Variables
  RED="\033[31m"
  WHITE="\033[37m"
  BOLD="\033[1m"
  RESET="\033[0m"

  TODO=$(mktemp)
  CHECK=$(mktemp)
  TODO_STRING="TODO-SAM"
  TODO_FILE=$NOTE_FILE-todo
  REGEX='^[0-9]+$'

  if [ $# -eq 0 ]
  then
    if [[ -f $TODO_FILE && -s $TODO_FILE ]]
    then
      grep "^!" $TODO_FILE | sed 's/\(^!.*\)/ \x1b[1;31m\1\x1b[0m/'
      grep "^-" $TODO_FILE | sed 's/\(^-\)/ \x1b[1;31m\1\x1b[0m/'
      grep "^+" $TODO_FILE | sed 's/\(^+\)/ \x1b[1;32m\1\x1b[0m/'
    else
      echo -e "There are currently no TODOs"
    fi
  elif [ $1 == "add" ]
  then
    if [ $# -eq 1 ]
    then
      echo "Nothing given to add..."
      exit 1
    fi

    ENTRY=$(echo $2 | awk '{$1=$1};1') # trim whitespace

    if [[ ${ENTRY:0:1} != "!" && ${ENTRY:0:1} != "-" && ${ENTRY:0:1} != "+" ]]
    then
      ENTRY=$(echo "- $ENTRY")
    fi

    echo "$ENTRY" >> $TODO_FILE
  elif [ $1 == "display" ]
  then
    if [ ! -z $2 ]
    then
      BASE_DIR=$2
      if [ -d $BASE_DIR ]
      then
        GREP_BASE_DIR=$BASE_DIR/*
      else
        echo "'$2' is not a directory"
        exit 1
      fi
    fi

    if [[ $2 =~ $REGEX ]]
    then
      SLEEPTIME=$2
    else
      SLEEPTIME=1
    fi


    # Perform Initialisation
    clear; printf $BOLD$WHITE"Initialising..."$RESET

    trap finish SIGINT         # Make sure script runs the finish function
    trap finish SIGTERM        # before ending, even if CTRL-C is used
    trap draw_screen SIGWINCH  # Re-draw screen if terminal size changes

    tput civis                 # Make the cursor invisible during the script

    stty -echo                 # Prevent user input during script


    # Main Loop
    while true
    do
      grep -IrH $TODO_STRING $GREP_BASE_DIR 2> /dev/null | sed "s/^\(.*\):.*$TODO_STRING \(.*\)/[\1]\n - \2/g" | sed 's/\*\/.*//g' > $CHECK

      if [[ -f $TODO_FILE && -s $TODO_FILE ]]
      then
        echo "[NOTES FILE]" >> $CHECK
        todo >> $CHECK
      fi

      BUFFER=$(awk '!seen[$0]++' $CHECK | sed "s/^\[\(.*\)\]$/`printf "$BOLD$WHITE["`\1`printf "$WHITE]$RESET"`/g")

      if [ -z "$BUFFER" ]
      then
        printf $BOLD$WHITE"There are currently no TODOs$RESET" > $CHECK
      else
        echo -e "$BUFFER" > $CHECK
      fi

      cmp --silent $TODO $CHECK || ( cp $CHECK $TODO; clear; draw_screen )
      sleep $SLEEPTIME
    done
  elif [ $1 == "done" ]
  then
    if [ $# -eq 1 ]
    then
      echo "No search string given"
      exit 1
    fi

    count=`grep $2 $TODO_FILE | wc -l`
    if [ $count -eq 0 ]
    then
      echo "Search string didn't match any TODOs"
      exit 1
    elif [ $count -ne 1 ]
    then
      echo "Search string matched $count TODOs, be more specific!"
      exit 1
    fi

    if grep $2 $TODO_FILE | grep -q "^+"
    then
      echo "TODO is already marked as done"
      exit 1
    fi

    sed -i "s/^. \(.*$2\)/+ \1/" $TODO_FILE
  elif [ $1 == "edit" ]
  then
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
      elif command -v nano > /dev/null
      then
        EDITOR=nano
      else
        echo "Could not find editor to use"
        exit 1
      fi
    fi

    $EDITOR $TODO_FILE
  elif [ $1 == "help" ] || [ $1 == "--help" ]
  then
    echo "TODO management by Sam Amis"
    echo ""
    echo "List of commands:"
    echo "  add"
    echo "  display"
    echo "  done"
    echo "  edit"
    echo "  help"
    echo "  remove"
    echo "  urgent"
    exit 0
  elif [ $1 == "remove" ]
  then
    if [ $# -eq 1 ]
    then
      echo "No search string given"
      exit 1
    fi

    count=`grep $2 $TODO_FILE | wc -l`
    if [ $count -eq 0 ]
    then
      echo "Search string didn't match any TODOs"
      exit 1
    elif [ $count -ne 1 ]
    then
      echo "Search string matched $count results, be more specific!"
      exit 1
    fi

    sed -i "/$2/d" $TODO_FILE
  elif [ $1 == "urgent" ]
  then
    if [ $# -eq 1 ]
    then
      echo "Nothing given to add..."
      exit 1
    fi

    ENTRY=$(echo $2 | awk '{$1=$1};1') # trim whitespace

    echo "! $ENTRY" >> $TODO_FILE
  else
    echo "Unknown option: $1"
    exit 1
  fi
}
