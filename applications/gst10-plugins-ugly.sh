#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GStreamer Ugly Plug-ins is abr3ak set of plug-ins considered by the GStreamer developers to have good quality andbr3ak correct functionality, but distributing them might pose problems.br3ak The license on either the plug-ins or the supporting librariesbr3ak might not be how the GStreamerbr3ak developers would like. The code might be widely known to presentbr3ak patent problems.br3ak"
SECTION="multimedia"
VERSION=1.14.4
NAME="gst10-plugins-ugly"

#REQ:gst10-plugins-base
#REC:liba52
#REC:libdvdread
#REC:x264
#OPT:gtk-doc
#OPT:libmpeg2
#OPT:libcdio
#OPT:valgrind


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz

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
            --with-package-name="GStreamer Ugly Plugins 1.14.4 BLFS" \
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
