#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libpng package containsbr3ak libraries used by other programs for reading and writing PNG files.br3ak The PNG format was designed as a replacement for GIF and, to abr3ak lesser extent, TIFF, with many improvements and extensions and lackbr3ak of patent problems.br3ak"
SECTION="general"
VERSION=1.6.35
NAME="libpng"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.35.tar.xz
wget -nc https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.35-apng.patch.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.35-apng.patch.gz

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

gzip -cd ../libpng-1.6.35-apng.patch.gz | patch -p1


LIBS=-lpthread ./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -v /usr/share/doc/libpng-1.6.35 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.35

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
