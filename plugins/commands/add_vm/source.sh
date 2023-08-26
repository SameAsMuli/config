#!/bin/sh

if [ -z "$CONFIG_DIR" ]; then
  >&2 echo "$0: \$CONFIG_DIR not defined"
  return 1
fi

. "$CONFIG_DIR"/utils/log.sh

# Enable password-less ssh to another VM
add_vm ()
{
  help_text "add_vm <user>@<hostname>" "Enable password-less ssh to another VM" "$@"
  check_arg_count 1 $# 1

  if [ ! -f ~/.ssh/id_rsa.pub ] || [ ! -s ~/.ssh/id_rsa.pub ]
  then
    info "Public ssh key does not exist... Generating now:"
    ssh-keygen -t rsa

    if [ ! -f ~/.ssh/id_rsa.pub ] || [ ! -s ~/.ssh/id_rsa.pub ]
    then
      err "Failed to generate public key"
    fi
  fi

  ssh "$1" 'if [ ! -f ~/.ssh/authorized_keys ]; then
              mkdir -p ~/.ssh;
              touch ~/.ssh/authorized_keys;
            fi;
            cat >> ~/.ssh/authorized_keys;
            chmod 644 ~/.ssh/authorized_keys;
            chmod 700 ~/.ssh;
            chmod 755 ~/.' < ~/.ssh/id_rsa.pub || err "Failed to connect to '$1'"
}
