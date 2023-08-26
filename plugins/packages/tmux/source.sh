#!/bin/sh

alias tmux='TERM=screen-256color tmux -f $CONFIG_DIR/plugins/tmux/tmux.conf -u'
alias ta="tmux attach-session -t"
alias tn="tmux new-session -s"
