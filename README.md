# Config
My collection of configuration and dot files for setting up a new system.

Once cloned onto a new system, the following instructions need to be followed:
 * Add the following line to your .bashrc (or equivalent):
   ```
   [ -f PATH_TO_CONFIG/.setup.sh ] && source PATH_TO_CONFIG/.setup.sh
   ```
 * Open config/.package\_config/vim/vimrc and run `:PlugInstall`
