#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Libkdcraw is a KDE wrapper aroundbr3ak the <a class=\"xref\" href=\"../general/libraw.html\" title=\"libraw-0.19.0\">libraw-0.19.0</a> library for manipulating imagebr3ak metadata.br3ak"
SECTION="kde"
VERSION=18.08.0
NAME="libkdcraw"

#REQ:libraw
#REQ:kframeworks5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/18.08.0/src/libkdcraw-18.08.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/18.08.0/src/libkdcraw-18.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkdcraw/libkdcraw-18.08.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libkdcraw-18.08.0-libraw19-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libkdcraw/libkdcraw-18.08.0-libraw19-1.patch

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

patch -Np1 -i ../libkdcraw-18.08.0-libraw19-1.patch &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
