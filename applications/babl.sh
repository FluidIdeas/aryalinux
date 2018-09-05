#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Babl package is a dynamic, anybr3ak to any, pixel format translation library.br3ak"
SECTION="general"
VERSION=0.1.50
NAME="babl"



cd $SOURCE_DIR

URL=https://download.gimp.org/pub/babl/0.1/babl-0.1.50.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://download.gimp.org/pub/babl/0.1/babl-0.1.50.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/babl/babl-0.1.50.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/babl/babl-0.1.50.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.50.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.50.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.50.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.50.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/gtk-doc/html/babl/graphics &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/babl &&
install -v -m644 docs/graphics/*.{html,png,svg} /usr/share/gtk-doc/html/babl/graphics

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
