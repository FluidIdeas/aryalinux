#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="MPV is a free, open source, and cross-platform media player"
SECTION="multimedia"
VERSION=0.29.0
NAME="gimp-gtk3"

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
#REC:iso-codes
#REC:libgudev
#REC:python-modules#pygtk
#REC:xdg-utils
#OPT:aalib
#OPT:alsa-lib
#OPT:gvfs
#OPT:libmng
#OPT:libwebp
#OPT:openjpeg2
#OPT:gtk-doc

cd $SOURCE_DIR

URL=https://gitlab.gnome.org/GNOME/gimp/-/archive/gtk3-port/gimp-gtk3-port.tar.bz2

if [ ! -z $URL ]
then
wget -nc $URL

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

./autogen.sh --prefix=/usr \
            --sysconfdir=/etc &&
make "-j`nproc`" || make
sudo make install
sudo gtk-update-icon-cache &&
sudo update-desktop-database


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
