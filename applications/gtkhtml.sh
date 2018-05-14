#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GtkHTML package contains abr3ak lightweight HTML rendering/printing/editing engine.br3ak"
SECTION="gnome"
VERSION=4.10.0
NAME="gtkhtml"

#REQ:enchant
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:iso-codes
#REC:libsoup


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.10/gtkhtml-4.10.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.10/gtkhtml-4.10.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
