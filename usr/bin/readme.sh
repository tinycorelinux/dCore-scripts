#!/bb/ash
. /etc/init.d/tc-functions

PATH="/bb:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH
BUILD=`getBuild`
MIRROR=`cat /opt/tcemirror`
README="$1"
checknotroot
[ -f /tmp/select.ans ] && sudo rm /tmp/select.ans

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

exit_tcnet() {
	echo "There is an issue connecting to "$MIRROR", exiting.."
	exit 1
}

if /bb/wget -s "$MIRROR" > /dev/null 2>&1; then
	:
else
	exit_tcnet
fi

if [ -z "$1" ]; then
	wget -q "$MIRROR"/dCore/"$BUILD"/README/READMELIST -O /tmp/READMELIST
	select2 "Select README file." /tmp/READMELIST	
	README="$(cat  /tmp/select.ans)"
fi

if [ -z "$README" ]; then
	echo "No selection made, exiting.."
	exit 0
fi

[ -f /tmp/README-"$README".txt ] && rm /tmp/README-"$README".txt
if wget -s "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt > /dev/null 2>&1; then
   wget -q "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt -O /tmp/README-"$README".txt 
   more /tmp/README-"$README".txt
   exit 1
else 
   echo ""$README" does not have a README file, exiting..."
fi

