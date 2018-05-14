#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libgusb package contains thebr3ak GObject wrappers for libusb-1.0br3ak that makes it easy to do asynchronous control, bulk and interruptbr3ak transfers with proper cancellation and integration into a mainloop.br3ak"
SECTION="general"
VERSION=0.3.0
NAME="libgusb"

#REQ:libusb
#REC:gtk-doc
#REC:gobject-introspection
#REC:usbutils
#REC:vala


cd $SOURCE_DIR

URL=https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.3.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
meson --prefix=/usr &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
