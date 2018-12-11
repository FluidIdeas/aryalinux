#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The cups-pk-helper packagebr3ak contains a PolicyKit helper usedbr3ak to configure Cups withbr3ak fine-grained privileges.br3ak"
SECTION="general"
VERSION=0.2.6
NAME="cups-pk-helper"

#REQ:cups
#REQ:polkit


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.6.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
