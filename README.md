# Config
My collection of configuration and dot files for setting up a new system.

Once cloned onto a new system, the following instructions need to be followed:
 * Add the following line to your .bashrc (or equivalent):
   ```
   [ -f PATH_TO_CONFIG/.setup.sh ] && source PATH_TO_CONFIG/.setup.sh
   ```
 * Open config/.package\_config/vim/vimrc and run `:PlugInstall`

 * Add the following to the cron table to auto-clear $DEL\_DIR:
   ```
   source $HOME/.bash_profile && type -t clear_deleted > /dev/null && clear_deleted
   ```
