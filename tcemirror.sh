#!/bb/ash
. /etc/init.d/tc-functions

PATH="/bb:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH

TMP=/tmp/select.$$
LOCAL=/opt/localmirrors
MIRRORS="/usr/local/share/mirrors"

[ -f "$LOCAL" ] && cat "$LOCAL" > "$TMP"
[ -f "$MIRRORS" ] && cat "$MIRRORS" >> "$TMP"
if [ ! -s "$TMP" ]; then
   echo "Requires mirrors.sce extension or /opt/localmirrors"
   exit 1
fi
select "Tiny Core Linux - Mirror Selection" "$TMP"
ANS="$(cat  /tmp/select.ans)"
rm "$TMP"
[ "$ANS" != "q" ] && echo "$ANS" > /opt/tcemirror
