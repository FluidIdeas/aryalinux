#!/bin/bash

set -e

. /etc/alps/alps.conf

NAME="gst-plugins-ugly"
VERSION="0.10.19"
. /var/lib/alps/functions

#REQ:gst-plugins-base
#REC:lame
#REC:libdvdnav
#REC:libdvdread
#OPT:liba52
#OPT:libcdio
#OPT:libmad
#OPT:libmpeg2
#OPT:x264
#OPT:gtk-doc
#OPT:python2


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-ugly-0.10.19-libcdio_fixes-1.patch
wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../gst-plugins-ugly-0.10.19-libcdio_fixes-1.patch &&
./configure --prefix=/usr \
            --with-package-name="GStreamer Ugly Plugins 0.10.19 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C docs/plugins install-data

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
