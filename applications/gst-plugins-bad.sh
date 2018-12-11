#!/bin/bash

set -e

. /etc/alps/alps.conf

NAME="gst-plugins-bad"
VERSION="0.10.23"
. /var/lib/alps/functions

#REQ:gst-plugins-base
#REC:faac
#REC:libpng
#REC:libvpx
#REC:openssl10
#REC:xvid
#OPT:curl
#OPT:faad2
#OPT:jasper
#OPT:libass
#OPT:libmusicbrainz
#OPT:librsvg
#OPT:libsndfile
#OPT:libvdpau
#OPT:neon
#OPT:sdl
#OPT:soundtouch


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed -e '/Some compatibility/ s:*/::' \
    -e '/const char/ i*/'            \
    -i  ext/vp8/gstvp8utils.h


./configure --prefix=/usr      \
            --with-gtk=3.0     \
            --disable-examples \
            --disable-static   \
            --with-package-name="GStreamer Bad Plugins 0.10.23 BLFS" \
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
