#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gcr package contains librariesbr3ak used for displaying certificates and accessing key stores. It alsobr3ak provides the viewer for crypto files on the GNOME Desktop.br3ak"
SECTION="gnome"
VERSION=3.28.0
NAME="gcr"

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REC:gnupg
#REC:gobject-introspection
#REC:gtk3
#REC:libxslt
#REC:vala
#OPT:gtk-doc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcr/gcr-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz

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

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --without-gtk-doc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
