# Install Tmux package manager if not already present
if [ ! -d ~/.tmux/plugins/tpm ]
then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
