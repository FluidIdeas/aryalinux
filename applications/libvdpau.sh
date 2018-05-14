#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="libvdpau"
VERSION="1.1.1"

#REQ:x7lib
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

wget -nc http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

./configure $XORG_CONFIG \
            --docdir=/usr/share/doc/libvdpau-1.1.1 &&
make

sudo tee /usr/lib/pkgconfig/vdpau.pc <<"EOF"
prefix=@prefix@
exec_prefix=@exec_prefix@
libdir=@libdir@
includedir=@includedir@
moduledir=@moduledir@

Name: VDPAU
Description: The Video Decode and Presentation API for UNIX
Version: @PACKAGE_VERSION@
Requires.private: x11
Cflags: -I${includedir}
Libs: -L${libdir} -lvdpau
EOF

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
