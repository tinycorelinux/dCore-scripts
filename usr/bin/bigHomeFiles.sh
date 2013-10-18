#!/bb/ash
. /etc/init.d/tc-functions

PATH="/bb:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH

find ${HOME} -type f -size +1024k | xargs ls -lSh 2>/dev/null |  awk '{printf "%s\t%s\n",$5,$9}'
