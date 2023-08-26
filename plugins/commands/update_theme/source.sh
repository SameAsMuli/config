update_theme() {
  if ! type -t tmux >/dev/null; then
    return
  fi

  # Update any vim sessions
  for wix in $(tmux list-windows -F '#{session_name}:#{window_index}'); do
    for pix in $(tmux list-panes -F '#{session_name}:#{window_index}.#{pane_index}' -t $wix); do
      tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix escape ENTER"
      tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix ':call ChangeBackground()' ENTER C-l"
    done
  done
}

if type -t dark-mode-notify &> /dev/null; then
  if [ "$1" = "--run" ]; then
    update_theme
  elif [ $(pgrep dark-mode-notify | wc -l) -eq 0 ]; then
    # Start the notify script
    (dark-mode-notify $CUSTOM_CONFIG_COMMANDS_DIR/update_theme.sh --run &) 2> /dev/null
  fi
fi
