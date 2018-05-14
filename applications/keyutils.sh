#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Keyutils is a set of utilities for managing the key retentionbr3ak facility in the kernel, which can be used by filesystems, blockbr3ak devices and more to gain and retain the authorization andbr3ak encryption keys required to perform secure operations.br3ak"
SECTION="general"
VERSION=1.5.10
NAME="keyutils"



cd $SOURCE_DIR

URL=http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.10.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.10.tar.bz2

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

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make NO_ARLIB=1 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
