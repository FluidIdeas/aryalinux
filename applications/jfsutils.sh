#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The jfsutils package containsbr3ak administration and debugging tools for the jfs file system.br3ak"
SECTION="postlfs"
VERSION=1.1.15
NAME="jfsutils"



cd $SOURCE_DIR

URL=http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz

if [ ! -z $URL ]
then
wget -nc http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz

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

sed "s@<unistd.h>@&\n#include <sys/types.h>@g" -i fscklog/extract.c &&
./configure &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
