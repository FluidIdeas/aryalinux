#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Exiv2 is a C++ library and abr3ak command line utility for managing image and video metadata.br3ak"
SECTION="general"
VERSION=0.26
NAME="exiv2"

#REC:curl
#OPT:doxygen
#OPT:graphviz
#OPT:libxslt


cd $SOURCE_DIR

URL=http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exiv2/exiv2-0.26-trunk.tar.gz

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

./configure --prefix=/usr     \
            --enable-video    \
            --enable-webready \
            --without-ssh     \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libexiv2.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
