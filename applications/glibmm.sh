#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GLibmm package is a set of C++br3ak bindings for GLib.br3ak"
SECTION="general"
VERSION=2.56.0
NAME="glibmm"

#REQ:glib2
#REQ:libsigc
#OPT:doxygen
#OPT:glib-networking
#OPT:gnutls
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glibmm/2.56/glibmm-2.56.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/glibmm/2.56/glibmm-2.56.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.56.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glibmm/2.56/glibmm-2.56.0.tar.xz

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

sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.56.0/' \
    -i docs/Makefile.in


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
