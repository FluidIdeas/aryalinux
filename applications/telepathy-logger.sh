#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:sqlite
#REQ:telepathy-glib
#REC:gobject-introspection
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2

NAME=telepathy-logger
VERSION=0.8.2.
URL=https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2

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

sed 's@/apps/@/org/freedesktop/@' \
-i data/org.freedesktop.Telepathy.Logger.gschema.xml.in
./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
