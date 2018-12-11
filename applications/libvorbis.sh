#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libvorbis package contains abr3ak general purpose audio and music encoding format. This is useful forbr3ak creating (encoding) and playing (decoding) sound in an open (patentbr3ak free) format.br3ak"
SECTION="multimedia"
VERSION=1.3.6
NAME="libvorbis"

#REQ:libogg
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libvorbis/libvorbis-1.3.6.tar.xz

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
make install &&
install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
