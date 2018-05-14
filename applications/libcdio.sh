#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libcdio is a library forbr3ak CD-ROM and CD image access. The associated libcdio-cdparanoia library reads audio frombr3ak the CD-ROM directly as data, with no analog step between, andbr3ak writes the data to a file or pipe as .wav, .aifc or as raw 16 bitbr3ak linear PCM.br3ak"
SECTION="multimedia"
VERSION=2.0.0
NAME="libcdio"

#OPT:libcddb


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-2.0.0.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz
wget -nc https://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcdio/libcdio-paranoia-10.2+0.94+2.tar.gz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../libcdio-paranoia-10.2+0.94+2.tar.gz &&
cd libcdio-paranoia-10.2+0.94+2 &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
