#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gst10-plugins-base
#REQ:cairo
#REQ:flac
#REQ:gdk-pixbuf
#REQ:lame
#REQ:libgudev
#REQ:libjpeg
#REQ:libpng
#REQ:libsoup
#REQ:libvpx
#REQ:mesa
#REQ:mpg123
#REQ:nasm
#REQ:x7lib


cd $SOURCE_DIR

NAME=gst10-plugins-good
VERSION=1.18.4
URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.18.4.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The GStreamer Good Plug-ins is a set of plug-ins considered by the GStreamer developers to have good quality code, correct functionality, and the preferred license (LGPL for the plug-in code, LGPL or LGPL-compatible for the supporting library). A wide range of video and audio decoders, encoders, and filters are included."


mkdir -pv $NAME
pushd $NAME

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.18.4.tar.xz


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

meson  --prefix=/usr       \
       -Dbuildtype=release \
       -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/svn/ \
       -Dpackage-name="GStreamer 1.18.4 BLFS" &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd