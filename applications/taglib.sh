#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Taglib is a library used forbr3ak reading, writing and manipulating audio file tags and is used bybr3ak applications such as Amarok andbr3ak VLC.br3ak"
SECTION="multimedia"
VERSION=1.11.1
NAME="taglib"

#REQ:cmake


cd $SOURCE_DIR

URL=https://taglib.github.io/releases/taglib-1.11.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://taglib.github.io/releases/taglib-1.11.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/taglib/taglib-1.11.1.tar.gz

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

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_SHARED_LIBS=ON \
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
