#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#mako
#REQ:libva
#REQ:libvdpau
#REQ:llvm
#REQ:wayland-protocols


cd $SOURCE_DIR

wget -nc https://mesa.freedesktop.org/archive/mesa-21.1.0.tar.xz


NAME=mesa
VERSION=21.1.0
URL=https://mesa.freedesktop.org/archive/mesa-21.1.0.tar.xz
SECTION="X Window System Environment"
DESCRIPTION="Mesa is an OpenGL compatible 3D graphics library."

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

export XORG_PREFIX="/usr"

sed '1s/python/&3/' -i bin/symbols-check.py
GALLIUM_DRV="auto"
DRI_DRIVERS="auto"

export XORG_PREFIX=/usr

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX          \
      -Dbuildtype=release            \
      -Dplatforms=auto               \
      -Ddri-drivers=$DRI_DRIVERS     \
      -Dgallium-drivers=$GALLIUM_DRV \
      -Dgallium-nine=false           \
      -Dglx=dri                      \
      -Dosmesa=gallium               \
      -Dvalgrind=false               \
      -Dlibunwind=false              \
      ..                             &&

unset GALLIUM_DRV DRI_DRIVERS &&

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

