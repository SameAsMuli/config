finish () {
  echo
  stty echo
  tput cnorm
  rm -f "$TICKER"
  rm -f "$CHECK"
  exit 0
}

draw_screen () {
  cat "$TICKER" | head -n $((`tput lines`-1))
}

display () {
  # In case the script takes a while, display initialisation text
  clear; printf Initialising...
  
  # Make sure script runs the finish function before ending
  trap finish SIGINT
  trap finish SIGTERM
  
  # Re-draw the screen if the terminal size changes
  trap draw_screen SIGWINCH
  
  # Make the cursor invisible during the script
  tput civis
  
  # Prevent visible user input during script
  stty -echo
  
  TICKER="$(mktemp)"
  CHECK="$(mktemp)"
  
  if [ -z "$SLEEPTIME" ]
  then
    SLEEPTIME=5
  fi
  
  while true
  do
    echo "$@" > "$CHECK"
    cmp --silent "$TICKER" "$CHECK" || ( cp "$CHECK" "$TICKER"; clear; draw_screen )
    sleep "$SLEEPTIME"
  done
}
