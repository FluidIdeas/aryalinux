#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak xdg-utils is a a set of commandbr3ak line tools that assist applications with a variety of desktopbr3ak integration tasks. It is required for Linux Standards Base (LSB)br3ak conformance.br3ak"
SECTION="xsoft"
VERSION=1.1.2
NAME="xdg-utils"

#REQ:xmlto
#REQ:lynx
#REQ:w3m
#REQ:links
#REQ:x7app
#OPT:dbus


cd $SOURCE_DIR

URL=https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://portland.freedesktop.org/download/xdg-utils-1.1.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.2.tar.gz

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

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
