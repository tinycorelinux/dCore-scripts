#!/bb/ash
. /etc/init.d/tc-functions

PATH="/bb:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH

if [ -z ${1} ]; then
  echo
  echo "         -=[ Simple Awk Calculator ]=-"
  echo "Put formula in quotes (single or double) examples:"
  echo "calc '3*4'"
  echo "calc 'sqrt(9)'"
  exit 0
fi
awk "BEGIN{ print $* }"
