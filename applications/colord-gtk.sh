#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Colord GTK package containsbr3ak GTK+ bindings for Colord.br3ak"
SECTION="x"
VERSION=0.1.26
NAME="colord-gtk"

#REQ:colord
#REQ:gtk3
#REC:gobject-introspection
#REC:vala
#OPT:docbook-utils
#OPT:gtk2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/colord/releases/colord-gtk-0.1.26.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/colord/releases/colord-gtk-0.1.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz

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
            --enable-vala    \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
