#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak XviD is an MPEG-4 compliant videobr3ak CODEC.br3ak"
SECTION="multimedia"
VERSION=1.3.5
NAME="xvid"

#OPT:yasm


cd $SOURCE_DIR

URL=http://downloads.xvid.org/downloads/xvidcore-1.3.5.tar.gz

if [ ! -z $URL ]
then
wget -nc http://downloads.xvid.org/downloads/xvidcore-1.3.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xvidcore/xvidcore-1.3.5.tar.gz

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

cd build/generic &&
sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile &&
make install &&
chmod -v 755 /usr/lib/libxvidcore.so.4.3 &&
install -v -m755 -d /usr/share/doc/xvidcore-1.3.5/examples &&
install -v -m644 ../../doc/* /usr/share/doc/xvidcore-1.3.5 &&
install -v -m644 ../../examples/* \
    /usr/share/doc/xvidcore-1.3.5/examples

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
