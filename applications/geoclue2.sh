#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:json-glib
#REQ:libsoup
#REQ:modemmanager
#REQ:vala
#REQ:avahi


cd $SOURCE_DIR

wget -nc https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.5.3/geoclue-2.5.3.tar.bz2


NAME=geoclue2
VERSION=2.5.3
URL=https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.5.3/geoclue-2.5.3.tar.bz2

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


mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc -Dgtk-doc=false .. &&
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

