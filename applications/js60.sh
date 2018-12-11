#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak JS is Mozilla's JavaScript enginebr3ak written in C. This package is present for GJS.br3ak"
SECTION="general"
VERSION=60.1.0
NAME="js60"

#REQ:autoconf213
#REQ:icu
#REQ:nspr
#REQ:python2
#REQ:x7lib
#REQ:yasm
#REQ:zip
#OPT:doxygen


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs-60.1.0.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2

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

mkdir mozjs-build &&
cd mozjs-build &&
../js/src/configure --prefix=/usr       \
            --with-intl-api     \
            --with-system-zlib  \
            --with-system-nspr  \
            --with-system-icu   \
            --disable-jemalloc  \
            --enable-readline   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
