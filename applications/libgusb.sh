#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libusb
#REQ:gtk-doc
#REQ:gobject-introspection
#REQ:usbutils
#REQ:vala


cd $SOURCE_DIR

wget -nc https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz


NAME=libgusb
VERSION=0.3.0
URL=https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz
SECTION="Miscellaneous"
DESCRIPTION="The libgusb package contains the GObject wrappers for libusb-1.0 that makes it easy to do asynchronous control, bulk and interrupt transfers with proper cancellation and integration into a mainloop."

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

meson --prefix=/usr -Ddocs=false .. &&
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

