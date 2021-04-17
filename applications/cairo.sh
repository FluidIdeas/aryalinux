#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libpng
#REQ:pixman
#REQ:fontconfig
#REQ:glib2
#REQ:x7lib


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/cairo/cairo-1.17.2+f93fc72c03e.tar.xz


NAME=cairo
VERSION=1.17.
URL=http://anduin.linuxfromscratch.org/BLFS/cairo/cairo-1.17.2+f93fc72c03e.tar.xz
SECTION="X Libraries"
DESCRIPTION="Cairo is a 2D graphics library with support for multiple output devices. Currently supported output targets include the X Window System, win32, image buffers, PostScript, PDF and SVG. Experimental backends include OpenGL, Quartz and XCB file output. Cairo is designed to produce consistent output on all output media while taking advantage of display hardware acceleration when available (e.g., through the X Render Extension). The Cairo API provides operations similar to the drawing operators of PostScript and PDF. Operations in Cairo include stroking and filling cubic Bézier splines, transforming and compositing translucent images, and antialiased text rendering. All drawing operations can be transformed by any affine transformation (scale, rotation, shear, etc.)."

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


autoreconf -fv              &&
./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
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

