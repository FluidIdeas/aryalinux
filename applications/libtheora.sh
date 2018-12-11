#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libtheora is a referencebr3ak implementation of the Theora video compression format beingbr3ak developed by the Xiph.Org Foundation.br3ak"
SECTION="multimedia"
VERSION=1.1.1
NAME="libtheora"

#REQ:libogg
#REC:libvorbis
#OPT:sdl
#OPT:libpng
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz

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

sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd examples/.libs &&
for E in *; do
  install -v -m755 $E /usr/bin/theora_${E}
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
