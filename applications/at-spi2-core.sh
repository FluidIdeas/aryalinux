#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The At-Spi2 Core package is a partbr3ak of the GNOME Accessibility Project. It provides a Service Providerbr3ak Interface for the Assistive Technologies available on thebr3ak GNOME platform and a librarybr3ak against which applications can be linked.br3ak"
SECTION="x"
VERSION=2.28.0
NAME="at-spi2-core"

#REQ:dbus
#REQ:glib2
#REQ:x7lib
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.28/at-spi2-core-2.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.28/at-spi2-core-2.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-core-2.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.28/at-spi2-core-2.28.0.tar.xz

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
meson --prefix=/usr --sysconfdir=/etc  .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
