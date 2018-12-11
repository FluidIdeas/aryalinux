#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GStreamer Base Plug-ins is abr3ak well-groomed and well-maintained collection of GStreamer plug-ins and elements, spanning thebr3ak range of possible types of elements one would want to write forbr3ak GStreamer. You will need at leastbr3ak one of Good, Bad, Ugly or Libav plugins for GStreamer applications to function properly.br3ak"
SECTION="multimedia"
VERSION=1.14.4
NAME="gst10-plugins-base"

#REQ:gstreamer10
#REC:alsa-lib
#REC:cdparanoia
#REC:gobject-introspection
#REC:iso-codes
#REC:libogg
#REC:libtheora
#REC:libvorbis
#REC:x7lib
#OPT:gtk3
#OPT:gtk-doc
#OPT:opus
#OPT:qt5
#OPT:sdl
#OPT:valgrind


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.14.4.tar.xz

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
            --with-package-name="GStreamer Base Plugins 1.14.4 BLFS" \
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
