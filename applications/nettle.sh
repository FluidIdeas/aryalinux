#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Nettle package contains abr3ak low-level cryptographic library that is designed to fit easily inbr3ak many contexts.br3ak"
SECTION="postlfs"
VERSION=3.4
NAME="nettle"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.4.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz

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
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.4 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
