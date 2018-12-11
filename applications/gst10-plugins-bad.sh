#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GStreamer Bad Plug-ins packagebr3ak contains a set of plug-ins that aren't up to par compared to thebr3ak rest. They might be close to being good quality, but they'rebr3ak missing something - be it a good code review, some documentation, abr3ak set of tests, a real live maintainer, or some actual wide use.br3ak"
SECTION="multimedia"
VERSION=1.14.4
NAME="gst10-plugins-bad"

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
#OPT:gnutls
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
#OPT:x7driver
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
#OPT:x265
#OPT:x7lib


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz

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

./configure --prefix=/usr                                           \
            --disable-wayland                                       \
            --disable-opencv                                        \
            --with-package-name="GStreamer Bad Plugins 1.14.4 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
