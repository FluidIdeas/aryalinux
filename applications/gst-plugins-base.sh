#!/bin/bash

set -e

. /etc/alps/alps.conf

NAME="gst-plugins-base"
VERSION="0.10.36"
. /var/lib/alps/functions

#REQ:gstreamer
#REQ:pango
#REC:alsa-lib
#REC:libgudev
#REC:libogg
#REC:libtheora
#REC:libvorbis
#REC:x7lib
#OPT:gobject-introspection
#OPT:cdparanoia
#OPT:gtk3
#OPT:check
#OPT:valgrind
#OPT:gtk-doc
#OPT:python2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz

#wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch
wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

#patch -Np1 -i ../gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch


./configure --prefix=/usr    \
            --disable-static \
            --with-package-name="GStreamer Base Plugins 0.10.36 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
