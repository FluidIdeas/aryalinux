#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gst10-plugins-base
#REC:libdvdread
#REC:libdvdnav
#REC:llvm
#REC:soundtouch
#OPT:bluez
#OPT:clutter
#OPT:curl
#OPT:faac
#OPT:faad2
#OPT:gtk-doc
#OPT:gtk2
#OPT:gtk3
#OPT:lcms2
#OPT:libass
#OPT:libexif
#OPT:libgcrypt
#OPT:libgudev
#OPT:libmpeg2
#OPT:libssh2
#OPT:libusb
#OPT:libvdpau
#OPT:libwebp
#OPT:neon
#OPT:nettle
#OPT:opencv
#OPT:openjpeg2
#OPT:opus
#OPT:qt5
#OPT:sdl
#OPT:valgrind
#OPT:wayland
#OPT:gtk3
#OPT:x265
#OPT:x7lib
#OPT:openal

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz

NAME=gst10-plugins-bad
VERSION=1.14.4
URL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--disable-wayland \
--disable-opencv \
--with-package-name="GStreamer Bad Plugins 1.14.4 BLFS" \
--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
