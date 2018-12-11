#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ATK provides the set ofbr3ak accessibility interfaces that are implemented by other toolkits andbr3ak applications. Using the ATKbr3ak interfaces, accessibility tools have full access to view andbr3ak control running applications.br3ak"
SECTION="x"
VERSION=2.30.0
NAME="atk"

#REQ:glib2
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/atk/2.30/atk-2.30.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/atk/2.30/atk-2.30.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at/atk-2.30.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/atk/2.30/atk-2.30.0.tar.xz

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
cd    build &&
meson --prefix=/usr &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
