CUSTOM_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_REFS_DIR="$CUSTOM_CONFIG_DIR/.refs"

if [ ! -d $CUSTOM_REFS_DIR ]
then
  mkdir -p $CUSTOM_REFS_DIR
fi

if [ -d $CUSTOM_CONFIG_DIR ]
then
  for file in $(find $CUSTOM_CONFIG_DIR -type f -not -name "*.md" -not -path '*/\.*')
  do
    source $file
  done
else
  unset CUSTOM_CONFIG_DIR
fi
