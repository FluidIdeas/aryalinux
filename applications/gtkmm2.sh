#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gtkmm package provides a C++br3ak interface to GTK+ 2. It can bebr3ak installed alongside <a class=\"xref\" href=\"gtkmm3.html\" title=\"Gtkmm-3.22.2\">Gtkmm-3.22.2</a> (the GTK+br3ak 3 version) with no namespace conflicts.br3ak"
SECTION="x"
VERSION=2.24.5
NAME="gtkmm2"

#REQ:atkmm
#REQ:gtk2
#REQ:pangomm


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz

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

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-2.24.5/' \
    -i docs/Makefile.in


CXXFLAGS="-g -O2 -std=c++11" ./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
