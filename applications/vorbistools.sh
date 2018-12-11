#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Vorbis Tools package containsbr3ak command-line tools useful for encoding, playing or editing filesbr3ak using the Ogg CODEC.br3ak"
SECTION="multimedia"
VERSION=1.4.0
NAME="vorbistools"

#REQ:libvorbis
#OPT:libao
#OPT:curl
#OPT:flac
#OPT:speex


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz

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

./configure --prefix=/usr \
            --enable-vcut \
            --without-curl &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
