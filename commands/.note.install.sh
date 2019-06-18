# Add auto-clear of DEL_DIR to a cronjob
CRONTAB='0 0 * * * source $HOME/.bash_profile && type -t clear_deleted > /dev/null && clear_deleted'
if ! crontab -l | grep -qF "$CRONTAB"
then
  (crontab -l 2>/dev/null; echo "$CRONTAB") | crontab -
fi
unset CRONTAB
