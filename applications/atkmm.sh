#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Atkmm is the official C++br3ak interface for the ATK accessibility toolkit library.br3ak"
SECTION="x"
VERSION=2.24.2
NAME="atkmm"

#REQ:atk
#REQ:glibmm


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz

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

sed -e '/^libdocdir =/ s/$(book_name)/atkmm-2.24.2/' \
    -i doc/Makefile.in


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
