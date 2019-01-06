#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus
#REQ:glib2
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz

NAME=dbus-glib
VERSION=0.110
URL=https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
