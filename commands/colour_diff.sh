# Provide mercurial-style colouring to the default diff function
function diff()
{
  command diff -u $@ | sed '0,/\(--- .*\)/s//\x1b[1;31m\1/;0,/\(+++ .*\)/s//\x1b[1;32m\1/;s/^-/\x1b[31m-/;s/^+/\x1b[32m+/;s/^@/\x1b[35m@/;s/$/\x1b[0m/' | less -FRSX
}
