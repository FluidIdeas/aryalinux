#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libmypaint package, a.k.a.br3ak \"brushlib\", is a library for making brushstrokes which is used bybr3ak MyPaint and other projects.br3ak"
SECTION="general"
VERSION=1.3.0
NAME="libmypaint"

#REQ:json-c
#REC:glib2
#REC:gobject-introspection
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmypaint/libmypaint-1.3.0.tar.xz

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
