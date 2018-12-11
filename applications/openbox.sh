#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Openbox is a highly configurablebr3ak desktop window manager with extensive standards support. It allowsbr3ak you to control almost every aspect of how you interact with yourbr3ak desktop.br3ak"
SECTION="x"
VERSION=3.6.1
NAME="openbox"

#REQ:pango
#REQ:xorg-server
#OPT:dbus
#OPT:imlib2
#OPT:python-modules#pyxdg
#OPT:startup-notification
#OPT:librsvg


cd $SOURCE_DIR

URL=http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz
wget -nc http://ftp.de.debian.org/debian/pool/main/n/numlockx/numlockx_1.2.orig.tar.gz

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

export LIBRARY_PATH=/usr/lib


2to3 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
