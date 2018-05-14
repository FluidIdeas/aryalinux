#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The dosfstools package containsbr3ak various utilities for use with the FAT family of file systems.br3ak"
SECTION="postlfs"
VERSION=4.1
NAME="dosfstools"



cd $SOURCE_DIR

URL=https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dosfstools/dosfstools-4.1.tar.xz

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

./configure --prefix=/               \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
