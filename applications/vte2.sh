#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Vte is a library (libvte)br3ak implementing a terminal emulator widget for GTK+ 2, and a minimal demonstrationbr3ak application (vte) that uses libvte.br3ak"
SECTION="lxde"
VERSION=0.28.2
NAME="vte2"

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python-modules#pygtk


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz

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

./configure --prefix=/usr \
            --libexecdir=/usr/lib/vte \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
