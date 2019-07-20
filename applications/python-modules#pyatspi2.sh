#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python-modules#pygobject3
#REQ:at-spi2-core


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.32/pyatspi-2.32.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pyatspi/2.32/pyatspi-2.32.1.tar.xz


NAME=python-modules#pyatspi2
VERSION=2.32.1
URL=http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.32/pyatspi-2.32.1.tar.xz

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

./configure --prefix=/usr --with-python=/usr/bin/python3
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
