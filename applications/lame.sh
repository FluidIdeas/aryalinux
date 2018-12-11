#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LAME package contains an MP3br3ak encoder and optionally, an MP3 frame analyzer. This is useful forbr3ak creating and analyzing compressed audio files.br3ak"
SECTION="multimedia"
VERSION=3.100
NAME="lame"

#OPT:libsndfile
#OPT:nasm


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lame/lame-3.100.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lame/lame-3.100.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lame/lame-3.100.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lame/lame-3.100.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.100.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lame/lame-3.100.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.100.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lame/lame-3.100.tar.gz

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

case $(uname -m) in
   i?86) sed -i -e 's/<xmmintrin.h/&.nouse/' configure ;;
esac


./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make pkghtmldir=/usr/share/doc/lame-3.100 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
