#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Opus is a lossy audio compressionbr3ak format developed by the Internet Engineering Task Force (IETF) thatbr3ak is particularly suitable for interactive speech and audiobr3ak transmission over the Internet. This package provides the Opusbr3ak development library and headers.br3ak"
SECTION="multimedia"
VERSION=1.2.1
NAME="opus"

#OPT:doxygen
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opus/opus-1.2.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/opus/opus-1.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.2.1.tar.gz

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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/opus-1.2.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
