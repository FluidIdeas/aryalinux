#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libaio package is anbr3ak asynchronous I/O facility (\"async I/O\", or \"aio\") that has a richerbr3ak API and capability set than the simple POSIX async I/O facility.br3ak This library, libaio, provides the Linux-native API for async I/O.br3ak The POSIX async I/O facility requires this library in order tobr3ak provide kernel-accelerated async I/O capabilities, as dobr3ak applications which require the Linux-native async I/O API.br3ak"
SECTION="general"
VERSION=0.3.111
NAME="libaio"



cd $SOURCE_DIR

URL=http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_0.3.111.orig.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_0.3.111.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libaio/libaio_0.3.111.orig.tar.gz

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

sed '/install.*libaio.a/s/^/#/' src/Makefile


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
