#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libisofs is a library to create anbr3ak ISO-9660 filesystem with extensions like RockRidge or Joliet.br3ak"
SECTION="multimedia"
VERSION=1.4.8
NAME="libisofs"



cd $SOURCE_DIR

URL=http://files.libburnia-project.org/releases/libisofs-1.4.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://files.libburnia-project.org/releases/libisofs-1.4.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libisofs/libisofs-1.4.8.tar.gz

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
