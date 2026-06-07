#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libwnck
#REQ:libxfce4ui
#REQ:desktop-file-utils
#REQ:xscreensaver
#REQ:polkit-gnome
#REQ:xfdesktop

cd $SOURCE_DIR
NAME=xfce4-session
VERSION=4.20.3
URL=https://archive.xfce.org/src/xfce/xfce4-session/4.20/xfce4-session-4.20.3.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.xfce.org/src/xfce/xfce4-session/4.20/xfce4-session-4.20.3.tar.bz2


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-legacy-sm
make
cat > ~/.xinitrc << "EOF"
dbus-launch --exit-with-x11 startxfce4
EOF

startx
startx &> ~/.x-session-errors
update-desktop-database
update-mime-database /usr/share/mime


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd