#!/bin/sh

# Aliases
alias config='cd $CONFIG_DIR'
alias grep='grep --color=auto -n'
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias please='sudo $(history -p !!)'

# Exports
export CDPATH="$CDPATH:$HOME"
export HISTTIMEFORMAT="%d/%m/%y %T"
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
export SSH_ASKPASS=""
export FIGNORE=".o:"
