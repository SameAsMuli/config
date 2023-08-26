#!/bin/sh

# Make the terminal's bell noise, if available
ding() {
  help_text "ding" "Make the terminal's bell noise, if available" "$@"
  check_arg_count 0 $# 0
  printf '\a'
}
