#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libxklavier package contains abr3ak utility library for X keyboard.br3ak"
SECTION="x"
VERSION=5.4
NAME="libxklavier"

#REQ:glib2
#REQ:iso-codes
#REQ:libxml2
#REQ:x7lib
#REC:gobject-introspection
#OPT:gtk-doc
#OPT:vala


cd $SOURCE_DIR

URL=https://people.freedesktop.org/~svu/libxklavier-5.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://people.freedesktop.org/~svu/libxklavier-5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
