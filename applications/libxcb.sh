#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libxcb package provides anbr3ak interface to the X Window System protocol, which replaces thebr3ak current Xlib interface. Xlib can also use XCB as a transport layer,br3ak allowing software to make requests and receive responses with both.br3ak"
SECTION="x"
VERSION=1.13.1
NAME="libxcb"

#REQ:libXau
#REQ:xcb-proto
#REC:libXdmcp
#OPT:doxygen
#OPT:libxslt


cd $SOURCE_DIR

URL=https://xcb.freedesktop.org/dist/libxcb-1.13.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://xcb.freedesktop.org/dist/libxcb-1.13.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.13.1.tar.bz2

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

sed -i "s/pthread-stubs//" configure &&
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.13.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
