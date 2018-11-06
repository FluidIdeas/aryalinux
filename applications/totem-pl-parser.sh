#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Totem PL Parser packagebr3ak contains a simple GObject-based library used to parse multiplebr3ak playlist formats.br3ak"
SECTION="gnome"
VERSION=3.26.1
NAME="totem-pl-parser"

#REQ:gmime3
#REQ:gmime
#REQ:libsoup
#REC:gobject-introspection
#REC:libarchive
#REC:libgcrypt
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.26.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.1.tar.xz

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
meson --prefix /usr --default-library shared .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
