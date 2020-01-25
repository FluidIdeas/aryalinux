#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:glib2
#REQ:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.32/at-spi2-core-2.32.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.32/at-spi2-core-2.32.1.tar.xz


NAME=at-spi2-core
VERSION=2.32.1
URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.32/at-spi2-core-2.32.1.tar.xz
SECTION="X Libraries"
DESCRIPTION="The At-Spi2 Core package is a part of the GNOME Accessibility Project. It provides a Service Provider Interface for the Assistive Technologies available on the GNOME platform and a library against which applications can be linked."

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


mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc  .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

