#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FFTW is a C subroutine library for computing the discrete Fourierbr3ak transform (DFT) in one or more dimensions, of arbitrary input size,br3ak and of both real and complex data (as well as of even/odd data,br3ak i.e. the discrete cosine/sine transforms or DCT/DST).br3ak"
SECTION="general"
VERSION=3.3.8
NAME="fftw"



cd $SOURCE_DIR

URL=http://www.fftw.org/fftw-3.3.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.fftw.org/fftw-3.3.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fftw/fftw-3.3.8.tar.gz || wget -nc ftp://ftp.fftw.org/pub/fftw/fftw-3.3.8.tar.gz

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

./configure --prefix=/usr  --enable-shared --enable-threads &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
