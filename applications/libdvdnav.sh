#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libdvdnav is a library that allowsbr3ak easy use of sophisticated DVD navigation features such as DVDbr3ak menus, multiangle playback and even interactive DVD games.br3ak"
SECTION="multimedia"
VERSION=6.0.0
NAME="libdvdnav"

#REQ:libdvdread


cd $SOURCE_DIR

URL=https://get.videolan.org/libdvdnav/6.0.0/libdvdnav-6.0.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://get.videolan.org/libdvdnav/6.0.0/libdvdnav-6.0.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdnav-6.0.0.tar.bz2

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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdnav-6.0.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
