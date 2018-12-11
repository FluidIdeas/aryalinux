#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libatomic_ops providesbr3ak implementations for atomic memory update operations on a number ofbr3ak architectures. This allows direct use of these in reasonablybr3ak portable code. Unlike earlier similar packages, this one explicitlybr3ak considers memory barrier semantics, and allows the construction ofbr3ak code that involves minimum overhead across a variety ofbr3ak architectures.br3ak"
SECTION="general"
VERSION=7.6.6
NAME="libatomic_ops"



cd $SOURCE_DIR

URL=https://github.com/ivmai/libatomic_ops/releases/download/v7.6.6/libatomic_ops-7.6.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/ivmai/libatomic_ops/releases/download/v7.6.6/libatomic_ops-7.6.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.6.6.tar.gz

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
            --enable-shared  \
            --disable-static \
            --docdir=/usr/share/doc/libatomic_ops-7.6.6 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
