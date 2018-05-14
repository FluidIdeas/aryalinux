#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The reiserfsprogs package containsbr3ak various utilities for use with the Reiser file system.br3ak"
SECTION="postlfs"
VERSION=3.6.27
NAME="reiserfs"



cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.27/reiserfsprogs-3.6.27.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.27/reiserfsprogs-3.6.27.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.27.tar.xz

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

autoreconf -fiv             &&
./configure --prefix=/usr   \
            --sbindir=/sbin &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
