#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libffi library provides abr3ak portable, high level programming interface to various callingbr3ak conventions. This allows a programmer to call any functionbr3ak specified by a call interface description at run time.br3ak"
SECTION="general"
VERSION=3.2.1
NAME="libffi"

#OPT:dejagnu


cd $SOURCE_DIR

URL=https://sourceware.org/ftp/libffi/libffi-3.2.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/ftp/libffi/libffi-3.2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz

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

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in &&
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in        &&
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
