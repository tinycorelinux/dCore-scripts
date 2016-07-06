#!/bb/ash
. /etc/init.d/tc-functions

PATH="/bb:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH
BUILD=`getBuild`
MIRROR=`cat /opt/tcemirror`
README="$1"
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo " "
	echo "${YELLOW}readme.sh - View README files for dCore packages.${NORMAL}"
	echo " "
	echo "Usage:"
	echo " "
	echo "${YELLOW}"readme.sh gcc"${NORMAL}             View the gcc readme file."
	echo "${YELLOW}"readme.sh"${NORMAL}             View available readme files."
	echo " "
fi

if [ -z "$1" ]; then
	wget -q "$MIRROR"/dCore/"$BUILD"/README/READMELIST -O /tmp/READMELIST
	select2 "Select README file." /tmp/READMELIST	
	README="$(cat  /tmp/select.ans)"
fi

[ -f /tmp/README-"$README".txt ] && rm /tmp/README-"$README".txt
if wget -s "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt > /dev/null 2>&1; then
   wget -q "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt -O /tmp/README-"$README".txt 
   more /tmp/README-"$README".txt
   exit 1
else 
   echo ""$README" does not have a README file, exiting..."
fi

