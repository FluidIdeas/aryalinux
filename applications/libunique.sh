#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libunique package contains abr3ak library for writing single instance applications.br3ak"
SECTION="general"
VERSION=1.1.6
NAME="libunique"

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libunique-1.1.6-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libunique/libunique-1.1.6-upstream_fixes-1.patch

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

patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr  \
            --disable-dbus \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
