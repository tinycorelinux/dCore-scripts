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
	echo "${YELLOW}readme.sh - View essential dCore README files to set up a dCore system${NORMAL}."
	echo "            Specific information to set up a TCE directory, graphics, sound,"
	echo "            wireless, gcc build essential compile tools, Window Managers,"
	echo "            Desktop Environments and specific software packages."
	echo " "
	echo "            Internet connection needed to access READMEs. Viewed READMEs"
	echo "            downloaded to /tmp/. To view READMEs use the Enter, spacebar,"
	echo "            Up/Down arrow and/or Page Up/Down keys, (q)uit exits."
	echo " "
	echo "            READMEs located at http://tinycorelinux.net/dCore/x86/README/."
	echo " "
	echo "Usage:"
	echo " "
	echo "${YELLOW}"readme.sh NAME"${NORMAL}    View specific README, example 'readme.sh 1st'."
	echo "${YELLOW}"readme.sh"${NORMAL}         Menu prompt, select README from list."
	echo " "
	exit 0
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

selectList () {
[ -f /tmp/select.ans ] && sudo rm /tmp/select.ans
if [ -z "$1" ]; then
	wget -q "$MIRROR"/dCore/"$BUILD"/README/READMELIST -O /tmp/READMELIST
	select2 "Select README. Use Page or Arrow Up/Down keys to read, (q)uit exits README." /tmp/READMELIST	
	README="$(cat  /tmp/select.ans)"
	[ -f /tmp/README-"$README".txt ] && rm /tmp/README-"$README".txt
	if wget -s "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt > /dev/null 2>&1; then
		wget -q "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt -O /tmp/README-"$README".txt
		clear
		less /tmp/README-"$README".txt
		selectList
	else
		echo "No selection made, exiting.."
		exit 0
	fi
fi
}

[ -f /tmp/README-"$README".txt ] && rm /tmp/README-"$README".txt
if wget -s "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt > /dev/null 2>&1; then
   wget -q "$MIRROR"/dCore/"$BUILD"/README/README-"$README".txt -O /tmp/README-"$README".txt
   clear
   more /tmp/README-"$README".txt
   exit 1
elif [ -z "$1" ]; then
	selectList
else
   echo "'"$README"' does not have a README file, exiting..."
fi
