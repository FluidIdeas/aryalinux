#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gst10-plugins-base
#REQ:liba52
#REQ:libdvdread
#REQ:x264


cd $SOURCE_DIR

NAME=gst10-plugins-ugly
VERSION=1.22.1
URL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.22.1.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The GStreamer Ugly Plug-ins is a set of plug-ins considered by the GStreamer developers to have good quality and correct functionality, but distributing them might pose problems. The license on either the plug-ins or the supporting libraries might not be how the GStreamer developers would like. The code might be widely known to present patent problems."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.22.1.tar.xz


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

meson  setup ..            \
       --prefix=/usr       \
       --buildtype=release \
       -Dgpl=enabled       \
       -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/systemd/ \
       -Dpackage-name="GStreamer 1.22.1 BLFS" &&
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