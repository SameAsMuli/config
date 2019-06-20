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

# Define deletion directory
DEL_DIR=$HOME/.deleted

if [ -d $DEL_DIR ]
then
  alias del="cd $DEL_DIR"
fi

# Define Last Deleted file
LAST_DEL=$CUSTOM_REFS_DIR/last_delete

function clear_deleted()
{
  # Include hidden files in the loop
  shopt -s dotglob

  for entity in $DEL_DIR/*
  do
    if [[ -d $entity ]]
    then
      command rm -r $entity
    elif [[ -f $entity ]]
    then
      command rm $entity
    fi
  done

  # Stop including hidden files
  shopt -u dotglob
}

function rm()
{
  SCRIPTPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

  ARGS=("$@")
  SIZE=${#ARGS[@]}

  if [[ 0 == $SIZE ]]
  then
    ARGS="--help"
  fi

  # Process input options
  if [[ "$(echo $ARGS | head -c 1)" == - ]]
  then
    if [[ "$ARGS" == "-r" || "$ARGS" == --remove ]]
    then
      for (( i=1; i<$SIZE; i++ ))
      do
        while true;
        do
          read -p "Delete '${ARGS[$i]}' without a backup - are you sure (Y or N)? " option
          case $option in
            [Yy]* ) command rm ${ARGS[$i]}; break;;
            [Nn]* ) return 1;;
            * ) echo "Delete '${ARGS[$i]}' without a backup - are you sure (Y or N)? ";;
          esac
        done
      done

      return 0

    elif [[ "$ARGS" == --restore ]]
    then
      if [[ $SIZE == 1 ]]
      then
        restore
      else
        for (( i=1; i<$SIZE; i++ ))
        do
          restore ${ARGS[$i]}
        done
      fi

      return 0

    elif [[ "$ARGS" == "-v" || "$ARGS" == --verbose ]]
    then
      OPTIONS=1
      VERBOSE=true
      FORCE=false

    elif [[ "$ARGS" == "-f" || "$ARGS" == --force ]]
    then
      OPTIONS=1
      VERBOSE=false
      FORCE=true

    elif [[ "$ARGS" == --help ]]
    then
      echo "NOTE: This is a custom rm function NOT the coreutils one."
      echo ""
      echo "Usage: rm [OPTION]... FILE..."
      echo "  or:  rm --restore"
      echo "  or:  rm --restore FILE..."
      echo ""
      echo "Unlike the standard rm function, no option is needed to specify"
      echo "whether we are removing files or directories."
      echo ""
      echo "  -r, --remove   force delete without making a backup"
      echo "      --restore  restore the file(s) to the original filepath(s)"
      echo "  -v, --verbose  explain what is being done"
      echo "      --help     display this help and exit"
      echo "      --version  output version information and exit"
      echo "  -f, --force    remove core files without prompting first"
      echo ""
      echo "If you specify more than one option, only the first one takes effect."
      echo ""
      echo "When using rm on `hostname -s`, all the files listed will be moved to"
      echo "the following directory rather than being deleted:"
      echo ""
      echo "  $DEL_DIR"
      echo ""
      echo "The full source code can be found in $SCRIPTPATH"
      return 0
    elif [[ "$ARGS" == --version ]]
    then
      echo "rm (`hostname -s`'s safe version) 1.5.2"
      echo "This is free software: you are free to change and redistribute it."
      echo "There is NO WARRANTY, to the extent permitted by law."
      echo ""
      echo "Written by Sam Amis, 06/07/17."
      return 0
    else
      echo "rm: invalid option -- '$ARGS'"
      echo "Try 'rm --help' for more information."
      return 1
    fi
  else
    OPTIONS=0
    VERBOSE=false
    FORCE=false
  fi

  # Check the deleted directory exists
  if [[ ! -d $DEL_DIR ]]
  then
    echo "NOTE: This is a custom rm function NOT the coreutils one."
    echo "      Use 'rm --help' for more information."
    echo ""
    echo "WARNING: '$DEL_DIR' does not exist."
    echo ""
    echo "D -       Delete without creating backup"
    echo "C -       Create '$DEL_DIR' and continue safe deletion"
    echo "Q -       Quit and stop deletion"
    echo ""

    while true;
    do
      read -p "Select Function : " option
      case $option in
        [Dd]* ) for (( i=0+$OPTIONS; i<$SIZE; i++ )); do command rm ${ARGS[$i]}; done; return 0;;
        [Cc]* ) mkdir $DEL_DIR && alias del="cd $DEL_DIR" && break || return 1;;
        [Qq]* ) return 1;;
        * ) echo "Please choose a valid option.";;
      esac
    done
  fi

  # Clear the last_delete record
  if [[ $SIZE > 0 ]]
  then
    > $LAST_DEL
  fi

  skip=false

  for (( i=0+$OPTIONS; i<$SIZE; i++ ))
  do
    # If it is a file
    if [[ -f ${ARGS[$i]} ]]
    then
      # Check if it's a core file
      if [[ ${ARGS[$i]} =~ core\..*$ ]]
      then
        if [[ $FORCE = true ]]
        then
          command rm -f ${ARGS[$i]}
          skip=true
        else
          while true;
          do
            read -p "Would you like to delete ${ARGS[$i]} without a backup (Y or N)? " option
            case $option in
              [Yy]* ) command rm ${ARGS[$i]}; skip=true; break;;
              [Nn]* ) skip=true; break;;
              * ) echo "Would you like to delete ${ARGS[$i]} without a backup (Y or N)? ";;
            esac
          done
        fi
      fi

      if [[ $skip = false ]]
      then
        # Record the old filepath
        dirname $(readlink -f ${ARGS[$i]}) > $DEL_DIR/.$(basename ${ARGS[$i]}).path

        # Delete any directory of the same name in DEL_DIR if necessary
        if [[ -d $DEL_DIR/$(basename ${ARGS[$i]}) ]]
        then
          command rm -rf $DEL_DIR/$(basename ${ARGS[$i]})
        fi

        # Move the file to DEL_DIR
        mv ${ARGS[$i]} $DEL_DIR

        # Add the basename to the last_delete record
        echo $(basename ${ARGS[$i]}) >> $LAST_DEL
      fi

    # If it is a directory
    elif [[ -d ${ARGS[$i]} ]]
    then
      # Record the old filepath
      dirname $(readlink -f ${ARGS[$i]}) > $DEL_DIR/.$(basename ${ARGS[$i]}).path

      # Delete any directory/file of the same name in DEL_DIR if necessary
      if [[ -d $DEL_DIR/$(basename ${ARGS[$i]}) ]]
      then
        command rm -rf $DEL_DIR/$(basename ${ARGS[$i]})
      elif [[ -f $DEL_DIR/$(basename ${ARGS[$i]}) ]]
      then
        command rm -f $DEL_DIR/$(basename ${ARGS[$i]})
      fi

      # Move the directory to DEL_DIR
      mv ${ARGS[$i]} $DEL_DIR

      # Add the basename to the last_delete record
      echo $(basename ${ARGS[$i]}) >> $LAST_DEL

    # If it does not exist
    else
      echo "rm: cannot remove '${ARGS[$i]}': No such file or directory"
      continue
    fi

    if [[ $skip = true ]]
    then
      if [[ $VERBOSE = true ]]
      then
        echo "'${ARGS[$i]}' deleted without a backup."
      fi

      skip=false

    elif [[ $VERBOSE = true ]]
    then
      echo "'${ARGS[$i]}' -> '$DEL_DIR/$(basename ${ARGS[$i]})'"
    fi
  done
}

function restore()
{
  ARGS=("$@")
  SIZE=${#ARGS[@]}

  if [[ $SIZE == 0 ]]
  then
    while read ENTITY
    do
      if [[ ! -f $DEL_DIR/$ENTITY && ! -d $DEL_DIR/$ENTITY ]]
      then
        echo "Cannot restore '$DEL_DIR/$ENTITY' as it does not exist"
        continue
      fi

      OLD_PATH="$(cat $DEL_DIR/.$ENTITY.path)"
      mv $DEL_DIR/$ENTITY $OLD_PATH
      command rm $DEL_DIR/.$ENTITY.path

      echo "Restored '$ENTITY' to '$OLD_PATH/$ENTITY'"
    done < $LAST_DEL

  else
    for (( i=0; i<$SIZE; i++ ))
    do
      ENTITY=${ARGS[$i]}

      if [[ ! -f $DEL_DIR/$ENTITY && ! -d $DEL_DIR/$ENTITY ]]
      then
        echo "Cannot restore '$DEL_DIR/$ENTITY' as it does not exist"
        continue
      fi

      OLD_PATH="$(cat $DEL_DIR/.$ENTITY.path)"
      mv $DEL_DIR/$ENTITY $OLD_PATH
      command rm $DEL_DIR/.$ENTITY.path

      echo "Restored '$ENTITY' to '$OLD_PATH/$ENTITY'"
    done
  fi
}
