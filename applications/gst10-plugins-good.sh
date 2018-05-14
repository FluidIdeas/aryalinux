#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GStreamer Good Plug-ins is abr3ak set of plug-ins considered by the GStreamer developers to have good qualitybr3ak code, correct functionality, and the preferred license (LGPL forbr3ak the plug-in code, LGPL or LGPL-compatible for the supportingbr3ak library). A wide range of video and audio decoders, encoders, andbr3ak filters are included.br3ak"
SECTION="multimedia"
VERSION=1.14.0
NAME="gst10-plugins-good"

#REQ:gst10-plugins-base
#REC:cairo
#REC:flac
#REC:lame
#REC:mpg123
#REC:mesa
#REC:gdk-pixbuf
#REC:libjpeg
#REC:libpng
#REC:libsoup
#REC:libvpx
#REC:x7lib
#OPT:aalib
#OPT:alsa-oss
#OPT:gtk3
#OPT:gtk-doc
#OPT:libdv
#OPT:libgudev
#OPT:pulseaudio
#OPT:speex
#OPT:taglib
#OPT:valgrind
#OPT:v4l-utils


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.14.0.tar.xz

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
            --with-package-name="GStreamer Good Plugins 1.14.0 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
