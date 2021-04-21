#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gstreamer10
#REQ:alsa-lib
#REQ:cdparanoia
#REQ:gobject-introspection
#REQ:iso-codes
#REQ:libgudev
#REQ:libogg
#REQ:libtheora
#REQ:libvorbis
#REQ:mesa
#REQ:wayland-protocols
#REQ:x7lib


cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.18.4.tar.xz


NAME=gst10-plugins-base
VERSION=1.18.4
URL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.18.4.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The GStreamer Base Plug-ins is a well-groomed and well-maintained collection of GStreamer plug-ins and elements, spanning the range of possible types of elements one would want to write for GStreamer. You will need at least one of Good, Bad, Ugly or Libav plugins for GStreamer applications to function properly."

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
       -Dpackage-origin=http://www.linuxfromscratch.org/blfs/view/svn/ \
       -Dpackage-name="GStreamer 1.18.4 BLFS"    \
       --wrap-mode=nodownload &&
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

