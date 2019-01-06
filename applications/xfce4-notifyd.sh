#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libnotify
#REQ:libxfce4ui
#REQ:xfce4-panel

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.3.tar.bz2

NAME=xfce4-notifyd
VERSION=0.4.3.
URL=http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.3.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

notify-send -i info Information "Hi ${USER}, This is a Test"

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
