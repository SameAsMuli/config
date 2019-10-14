# Enable passwordless ssh to another vm
add_vm ()
{
  if [ "$#" != "1" ]
  then
    echo "Usage: add_vm <user>@<hostname>"
    return 1
  fi

  cat ~/.ssh/id_rsa.pub | ssh $1 'if [ ! -f ~/.ssh/authorized_keys ]; then mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys; fi; cat >> ~/.ssh/authorized_keys; chmod 644 ~/.ssh/authorized_keys'
}
