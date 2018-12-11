#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Sharutils package containsbr3ak utilities that can create 'shell' archives.br3ak"
SECTION="general"
VERSION=4.15.2
NAME="sharutils"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz

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

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c        &&
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h &&
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
