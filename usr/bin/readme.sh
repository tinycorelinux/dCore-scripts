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
	clear
	echo "${YELLOW}readme.sh - View essential dCore README files to set up a dCore system${NORMAL}, includes"
	echo "            how to set up a TCE directory, graphics, sound, wireless, gcc build"
	echo "            essential compile tools, full featured LibreOffice, numerous Window"
	echo "            Managers/Desktop Environments and more."
	echo " "
	echo "            Internet connection needed to access READMEs through the readme.sh"
	echo "            command. To view READMEs, Enter key scrolls down one line, spacebar"
	echo "            pages down, (q)uit exits. READMEs downloaded to /tmp."
	echo " "
	echo "            READMEs located at http://tinycorelinux.net/dCore/x86/README/."
	echo " "
	echo "Usage:"
	echo " "
	echo "${YELLOW}"readme.sh NAME"${NORMAL}    View specific README, example 'readme.sh 1st'."
	echo "${YELLOW}"readme.sh"${NORMAL}         Menu prompt, select README to view from all available."
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
   clear
   more /tmp/README-"$README".txt
   exit 1
else 
   echo ""$README" does not have a README file, exiting..."
fi

