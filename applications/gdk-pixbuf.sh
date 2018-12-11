#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gdk Pixbuf package is abr3ak toolkit for image loading and pixel buffer manipulation. It is usedbr3ak by GTK+ 2 and GTK+ 3 to load and manipulate images. In thebr3ak past it was distributed as part of GTK+br3ak 2 but it was split off into a separate package inbr3ak preparation for the change to GTK+br3ak 3.br3ak"
SECTION="x"
VERSION=2.38.0
NAME="gdk-pixbuf"

#REQ:glib2
#REQ:libjpeg
#REQ:libpng
#REQ:shared-mime-info
#REC:libtiff
#REC:x7lib
#OPT:gobject-introspection
#OPT:jasper
#OPT:gtk-doc
#OPT:python-modules#six


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.38/gdk-pixbuf-2.38.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.38/gdk-pixbuf-2.38.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.38.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.38/gdk-pixbuf-2.38.0.tar.xz

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

mkdir build &&
cd build &&
meson --prefix=/usr .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gdk-pixbuf-query-loaders --update-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
