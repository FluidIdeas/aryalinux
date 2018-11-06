#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Netscape Portable Runtime (NSPR)br3ak provides a platform-neutral API for system level and libc likebr3ak functions.br3ak"
SECTION="general"
VERSION=4.20
NAME="nspr"



cd $SOURCE_DIR

URL=https://archive.mozilla.org/pub/nspr/releases/v4.20/src/nspr-4.20.tar.gz

if [ ! -z $URL ]
then
wget -nc https://archive.mozilla.org/pub/nspr/releases/v4.20/src/nspr-4.20.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nspr/nspr-4.20.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nspr/nspr-4.20.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nspr/nspr-4.20.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nspr/nspr-4.20.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nspr/nspr-4.20.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nspr/nspr-4.20.tar.gz

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

cd nspr                                                     &&
sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##'            config/rules.mk         &&
./configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
