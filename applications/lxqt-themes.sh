#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lxqt-themes package provides abr3ak number of graphic files and themes for ithe LXQt desktop.br3ak"
SECTION="lxqt"
VERSION=0.12.0
NAME="lxqt-themes"

#REQ:lxqt-build-tools


cd $SOURCE_DIR

URL=https://github.com/lxde/lxqt-themes/releases/download/0.12.0/lxqt-themes-0.12.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/lxde/lxqt-themes/releases/download/0.12.0/lxqt-themes-0.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-themes/lxqt-themes-0.12.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv $LXQT_PREFIX/share/lxqt/graphics &&
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
