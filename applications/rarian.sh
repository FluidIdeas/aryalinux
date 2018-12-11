#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Rarian package is abr3ak documentation metadata library based on the proposedbr3ak Freedesktop.org spec. Rarian isbr3ak designed to be a replacement for ScrollKeeper.br3ak"
SECTION="general"
VERSION=0.8.1
NAME="rarian"

#REC:libxslt
#REC:docbook


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2

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

./configure --prefix=/usr        \
            --disable-static     \
            --localstatedir=/var &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
