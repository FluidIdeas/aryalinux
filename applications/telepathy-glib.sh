#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus-glib
#REQ:libxslt
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz

NAME=telepathy-glib
VERSION=0.24.1
URL=https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz

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

./configure --prefix=/usr \
            --enable-vala-bindings \
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
