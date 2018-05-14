#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenOBEX package contains abr3ak library that implements Object Exchange Protocol used for binarybr3ak file transfers between devices.br3ak"
SECTION="general"
VERSION=1.7.2
NAME="openobex"

#REQ:cmake
#REQ:libusb
#REC:bluez
#OPT:doxygen
#OPT:libxslt
#OPT:openjdk
#OPT:xmlto


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/openobex/openobex-1.7.2-Source.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 90 plugdev

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_INSTALL_LIBDIR=/usr/lib  \
      -DCMAKE_BUILD_TYPE=Release       \
      -Wno-dev                         \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
