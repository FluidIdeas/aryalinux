#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gimp package contains the GNUbr3ak Image Manipulation Program which is useful for photo retouching,br3ak image composition and image authoring.br3ak"
SECTION="xsoft"
VERSION=2.10.6
NAME="gimp"

#REQ:gegl
#REQ:gexiv2
#REQ:glib-networking
#REQ:gtk2
#REQ:harfbuzz
#REQ:libjpeg
#REQ:libmypaint
#REQ:librsvg
#REQ:libtiff
#REQ:python-modules#libxml2py2
#REQ:lcms2
#REQ:mypaint-brushes
#REQ:poppler
#REQ:xorg-server
#REC:dbus-glib
#REC:gs
#REC:gvfs
#REC:iso-codes
#REC:libgudev
#REC:python-modules#pygtk
#REC:xdg-utils
#OPT:aalib
#OPT:alsa-lib
#OPT:libmng
#OPT:libwebp
#OPT:openjpeg2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://download.gimp.org/pub/gimp/v2.10/gimp-2.10.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://download.gimp.org/pub/gimp/v2.10/gimp-2.10.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.10.6.tar.bz2

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
            --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
