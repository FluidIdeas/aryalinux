#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Frei0r is a minimalistic pluginbr3ak API for video effects. Note that the 0 in the name is a zero, not abr3ak capital letter o.br3ak"
SECTION="multimedia"
VERSION=1.6.1
NAME="frei0r"



cd $SOURCE_DIR

URL=https://files.dyne.org/frei0r/releases/frei0r-plugins-1.6.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://files.dyne.org/frei0r/releases/frei0r-plugins-1.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.6.1.tar.gz

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

mkdir -vp build &&
cd        build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DOpenCV_DIR=/usr/share/OpenCV \
      -Wno-dev ..                    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
