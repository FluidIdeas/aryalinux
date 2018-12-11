#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The bridge-utils package containsbr3ak a utility needed to create and manage bridge devices. This isbr3ak useful in setting up networks for a hosted virtual machine (VM).br3ak"
SECTION="basicnet"
VERSION=1.6
NAME="bridge-utils"

#OPT:net-tools


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/utils/net/bridge-utils/bridge-utils-1.6.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/utils/net/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.6.tar.xz

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

autoconf                  &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
