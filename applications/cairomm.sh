#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Cairomm package provides a C++br3ak interface to Cairo.br3ak"
SECTION="x"
VERSION=1.12.2
NAME="cairomm"

#REQ:cairo
#REQ:libsigc
#OPT:boost
#OPT:doxygen


cd $SOURCE_DIR

URL=https://www.cairographics.org/releases/cairomm-1.12.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.cairographics.org/releases/cairomm-1.12.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairomm-1.12.2.tar.gz

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

sed -e '/^libdocdir =/ s/$(book_name)/cairomm-1.12.2/' \
    -i docs/Makefile.in


./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
