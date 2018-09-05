#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Links is a text and graphics modebr3ak WWW browser. It includes support for rendering tables and frames,br3ak features background downloads, can display colors and has manybr3ak other features.br3ak"
SECTION="basicnet"
VERSION=2.16
NAME="links"

#OPT:gpm
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://links.twibright.com/download/links-2.16.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://links.twibright.com/download/links-2.16.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/links/links-2.16.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/links/links-2.16.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.16.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.16.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.16.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.16.tar.bz2

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
make install &&
install -v -d -m755 /usr/share/doc/links-2.16 &&
install -v -m644 doc/links_cal/* KEYS BRAILLE_HOWTO \
    /usr/share/doc/links-2.16

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
