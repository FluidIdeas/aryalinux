#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The XKeyboardConfig packagebr3ak contains the keyboard configuration database for the X Windowbr3ak System.br3ak"
SECTION="x"
VERSION=2.25
NAME="xkeyboard-config"

#REQ:x7lib


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.25.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --with-xkb-rules-symlink=xorg &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
