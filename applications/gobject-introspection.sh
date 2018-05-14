#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
DESCRIPTION="br3ak The GObject Introspection is usedbr3ak to describe the program APIs and collect them in a uniform, machinebr3ak readable format.br3ak"
SECTION="general"
VERSION=1.56.1
NAME="gobject-introspection"

#REQ:glib2
#REC:general_which
#OPT:cairo
#OPT:gtk-doc
#OPT:python-modules#Mako
#OPT:python2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.56/gobject-introspection-1.56.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.56/gobject-introspection-1.56.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.56.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.56/gobject-introspection-1.56.1.tar.xz

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
            --disable-static \
            --with-python=/usr/bin/python3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
