#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Cairo is a 2D graphics librarybr3ak with support for multiple output devices. Currently supportedbr3ak output targets include the Xbr3ak Window System, win32, image buffers, PostScript, PDF and SVG.br3ak Experimental backends include OpenGL, Quartz and XCB file output.br3ak Cairo is designed to producebr3ak consistent output on all output media while taking advantage ofbr3ak display hardware acceleration when available (e.g., through the Xbr3ak Render Extension). The Cairo APIbr3ak provides operations similar to the drawing operators of PostScriptbr3ak and PDF. Operations in Cairobr3ak include stroking and filling cubic B�zier splines, transforming andbr3ak compositing translucent images, and antialiased text rendering. Allbr3ak drawing operations can be transformed by any <a class=\"ulink\" href=\"http://en.wikipedia.org/wiki/Affine_transformation\">affinebr3ak transformation</a> (scale, rotation, shear, etc.).br3ak"
SECTION="x"
VERSION=1.16.0
NAME="cairo"

#REQ:libpng
#REQ:pixman
#REC:fontconfig
#REC:glib2
#REC:x7lib
#OPT:cogl
#OPT:gs
#OPT:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:libdrm
#OPT:librsvg
#OPT:lzo
#OPT:mesa
#OPT:poppler
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.cairographics.org/releases/cairo-1.16.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.cairographics.org/releases/cairo-1.16.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.16.0.tar.xz

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

./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
