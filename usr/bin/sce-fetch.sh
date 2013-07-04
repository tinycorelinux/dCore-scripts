#!/bin/busybox ash
. /etc/init.d/tc-functions
useBusybox
checknotroot
MIRROR=`cat /opt/tcemirror`
TCEDIR=/etc/sysconfig/tcedir
> /tmp/.file.lst
> /tmp/select.ans

VERSION=`getMajorVer`
ARCH=`getBuild`
while getopts bi OPTION
do 
	case ${OPTION} in 
		b) ONBOOT=TRUE ;;
		i) INSTALL=TRUE ;;
	esac
	
done
shift `expr $OPTIND - 1`
cd /etc/sysconfig/tcedir/sce
wget -O /tmp/.file.lst -cq "$MIRROR""$VERSION".x/"$ARCH"/sce/file.lst
if [ -z "$1" ]; then                                                                      
	echo -n "Enter starting characters of package sought: "                 
	read TARGET                                                             

	if grep "$TARGET" /tmp/.file.lst; then	
		{ grep "$TARGET" /tmp/.file.lst; echo quit ; } | sort | uniq | select "Select sce package for "$1"" "-"
		read PKG < /tmp/select.ans
	else
		cat /tmp/.file.lst | sort | select "Select sce package to download" "-"
		read PKG < /tmp/select.ans
	fi	
	[ "$PKG" == "q" ] && exit 1
	[ "$PKG" == "quit" ] && exit 1
	if [ -f "$PKG" ]; then
		echo "$PKG already exists, exiting..."
		exit 1
	fi 
  
	wget "$MIRROR""$VERSION".x/"$ARCH"/sce/"$PKG" 
	echo -n ""$PKG" is downloaded, would you like to install it now? (y/N): "
	read ans
	if [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
		loadsce "$PKG"
	fi
else
	PKG="$1"
	if [ ! -f "$PKG".sce ]; then 
		wget "$MIRROR""$VERSION".x/"$ARCH"/sce/"$PKG".sce || ( echo "$PKG is not an sce available for download." && exit 1 )
	else
		echo "$PKG.sce already exists, exiting..."
	fi
  
	if [ "$INSTALL" == "TRUE" ] && [ -f "$PKG".sce ]
	then
		loadsce "$PKG"
	fi
	if [ "$ONBOOT" == "TRUE" ] && [ -f "$PKG".sce ]
	then
		if ! grep -wq "$PKG" "$TCEDIR"/sceboot.lst
		then
			echo "$PKG" >> "$TCEDIR"/sceboot.lst
		fi
	fi
fi
