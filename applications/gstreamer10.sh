#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak gstreamer is a streaming mediabr3ak framework that enables applications to share a common set ofbr3ak plugins for things like video encoding and decoding, audio encodingbr3ak and decoding, audio and video filters, audio visualisation, webbr3ak streaming and anything else that streams in real-time or otherwise.br3ak This package only provides base functionality and libraries. Youbr3ak may need at least <a class=\"xref\" href=\"gst10-plugins-base.html\" br3ak title=\"gst-plugins-base-1.14.1\">gst-plugins-base-1.14.1</a> and onebr3ak of Good, Bad, Ugly or Libav plugins.br3ak"
SECTION="multimedia"
VERSION=1.14.1
NAME="gstreamer10"

#REQ:glib2
#REC:gobject-introspection
#OPT:gtk3
#OPT:gsl
#OPT:gtk-doc
#OPT:valgrind


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-1.14.1.tar.xz

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
            --with-package-name="GStreamer 1.14.1 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make "-j`nproc`" || make


rm -rf /usr/bin/gst-* /usr/{lib,libexec}/gstreamer-1.0



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
