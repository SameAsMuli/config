SETUP_SCRIPT=`dirname "${BASH_SOURCE[0]}"`/setup.sh
if [ -f $SETUP_SCRIPT ]
then
  source $SETUP_SCRIPT
else
  echo "$SETUP_SCRIPT script is missing"
  exit 1
fi

# Find any install scripts and run them
for f in $(find $CUSTOM_CONFIG_DIR -type f -name "*.install.sh")
do
  source $f
done

# Enable custom configuration only once everything is installed
ENABLE_CONFIG_COMMAND="[ -f $CUSTOM_CONFIG_DIR/setup.sh ] && source $CUSTOM_CONFIG_DIR/setup.sh"
if ! grep -sq "$ENABLE_CONFIG_COMMAND" ~/.bashrc
then
  echo "$ENABLE_CONFIG_COMMAND" >> ~/.bashrc
fi
