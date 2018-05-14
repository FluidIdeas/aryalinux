#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Pnmixer package provides abr3ak lightweight volume control with a tray icon.br3ak"
SECTION="multimedia"
VERSION=0.5.1
NAME="pnmixer"

#REQ:alsa-utils
#REQ:gtk2


cd $SOURCE_DIR

URL=https://github.com/downloads/nicklan/pnmixer/pnmixer-0.5.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/downloads/nicklan/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz

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

./autogen.sh --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
