#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Gavl is short for Gmerlin Audiobr3ak Video Library. It is a low level library that handles the detailsbr3ak of audio and video formats like colorspaces, samplerates,br3ak multichannel configurations etc. It provides standardizedbr3ak definitions for those formats as well as container structures forbr3ak carrying audio samples or video images inside an application.br3ak"
SECTION="multimedia"
VERSION=1.4.0
NAME="gavl"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/gmerlin/gavl-1.4.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/gmerlin/gavl-1.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz

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

LIBS=-lm                      \
./configure --prefix=/usr     \
            --without-doxygen \
            --docdir=/usr/share/doc/gavl-1.4.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
