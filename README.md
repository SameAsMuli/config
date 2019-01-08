# Config
My collection of configuration and dot files for setting up a new system.

Once cloned onto a new system, the following instructions need to be followed:

## Enable Custom Config
 * Add the following line to your .bashrc (or equivalent):
   ```
   [ -f PATH_TO_CONFIG/.setup.sh ] && source PATH_TO_CONFIG/.setup.sh
   ```

## Packages
### Tmux
 * Run the following in $CUSTOM\_CONFIG\_PACKAGES\_DIR/tmux/
   ```
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

### Vim
 * Open $CUSTOM\_CONFIG\_PACKAGES\_DIR/vim/vimrc and run `:PlugInstall`

## Custom Commands
### Safe Delete
 * Add the following to the cron table to auto-clear $DEL\_DIR:
   ```
   source $HOME/.bash_profile && type -t clear_deleted > /dev/null && clear_deleted
   ```
