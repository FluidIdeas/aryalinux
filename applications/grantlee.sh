#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Grantlee is a set of free software libraries written using the Qtbr3ak framework. Currently two libraries are shipped with Grantlee:br3ak Grantlee Templates and Grantlee TextDocument. The goal of Grantleebr3ak Templates is to make it easier for application developers tobr3ak separate the structure of documents from the data they contain,br3ak opening the door for theming.br3ak"
SECTION="general"
VERSION=5.1.0
NAME="grantlee"

#REQ:cmake
#REQ:qt5


cd $SOURCE_DIR

URL=http://downloads.grantlee.org/grantlee-5.1.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://downloads.grantlee.org/grantlee-5.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz

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
