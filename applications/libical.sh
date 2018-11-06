#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libical package contains anbr3ak implementation of the iCalendar protocols and data formats.br3ak"
SECTION="general"
VERSION=3.0.4
NAME="libical"

#REQ:cmake
#OPT:db
#OPT:doxygen
#OPT:gobject-introspection
#OPT:icu


cd $SOURCE_DIR

URL=https://github.com/libical/libical/releases/download/v3.0.4/libical-3.0.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/libical/libical/releases/download/v3.0.4/libical-3.0.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libical/libical-3.0.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libical/libical-3.0.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-3.0.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-3.0.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-3.0.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-3.0.4.tar.gz

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
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_BUILD_TYPE=Release       \
      -DSHARED_ONLY=yes                \
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
