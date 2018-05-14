#!/bin/bash

set -e

. /etc/alps/alps.conf

NAME="gst-plugins-good"
VERSION="0.10.31"
. /var/lib/alps/functions

#REQ:gst-plugins-base
#REC:cairo
#REC:flac
#REC:libjpeg
#REC:libpng
#REC:x7lib
#OPT:GConf
#OPT:libsoup
#OPT:aalib
#OPT:gtk3
#OPT:libdv
#OPT:pulseaudio
#OPT:speex
#OPT:taglib
#OPT:multimedia_atk
#OPT:gtk-doc
#OPT:python2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed -i -e "/input:/d" sys/v4l2/gstv4l2bufferpool.c &&
sed -i -e "/case V4L2_CID_HCENTER/d" -e "/case V4L2_CID_VCENTER/d" sys/v4l2/v4l2_calls.c &&
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-gtk=3.0 \
            --with-package-name="GStreamer Good Plugins 0.10.31 BLFS" \
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
