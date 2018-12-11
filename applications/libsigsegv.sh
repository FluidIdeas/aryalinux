#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This is a library for handling page faults in user mode. A pagebr3ak fault occurs when a program tries to access to a region of memorybr3ak that is currently not available. Catching and handling a page faultbr3ak is a useful technique for implementing pageable virtual memory,br3ak memory-mapped access to persistent databases, generational garbagebr3ak collectors, stack overflow handlers, and distributed shared memory.br3ak"
SECTION="general"
VERSION=2.12
NAME="libsigsegv"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.12.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz

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

./configure --prefix=/usr   \
            --enable-shared \
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
