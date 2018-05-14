#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="simpleburn"
VERSION="1.8.1"

#REQ:libcddb
#REQ:cmake
#REQ:gtk2
#REC:libisoburn
#REC:cdparanoia
#REC:cdrdao
#OPT:libcdio
#OPT:flac
#OPT:mpg123
#OPT:vorbistools
#OPT:lame
#OPT:mplayer


cd $SOURCE_DIR

URL=http://simpleburn.tuxfamily.org/IMG/gz/simpleburn-1.8.1.tar.gz

wget -nc http://simpleburn.tuxfamily.org/IMG/gz/simpleburn-1.8.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/simpleburn/simpleburn-1.8.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/simpleburn/simpleburn-1.8.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/simpleburn/simpleburn-1.8.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/simpleburn/simpleburn-1.8.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/simpleburn/simpleburn-1.8.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e 's|DESTINATION doc|DESTINATION share/doc|' CMakeLists.txt &&
mkdir build &&
cd    build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DBURNING=LIBBURNIA .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G cdrom `cat /tmp/currentuser`



cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
