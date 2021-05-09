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
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-21.1.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/mesa-21.1.0-add_xdemos-1.patch
wget -nc ftp://ftp.freedesktop.org/pub/mesa/demos/


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

patch -Np1 -i ../mesa-21.1.0-add_xdemos-1.patch
sed '1s/python/&3/' -i bin/symbols-check.py
GALLIUM_DRV="i915,iris,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"

export XORG_PREFIX=/usr

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX          \
      --sysconfdir=/etc              \
      -Dllvm=true                    \
      -Dshared-llvm=true             \
      -Degl=true                     \
      -Dshared-glapi=true            \
      -Dgallium-xa=true              \
      -Dgallium-nine=true            \
      -Dgallium-vdpau=true           \
      -Dgallium-va=true              \
      -Ddri3=true                    \
      -Dglx=dri                      \
      -Dosmesa=gallium               \
      -Dgbm=true                     \
      -Dglx-direct=true              \
      -Dgles1=true                   \
      -Dgles2=true                   \
      -Dvalgrind=false               \
      -Ddri-drivers=true             \
      -Dgallium-drivers=true         \
      -Dplatforms=true               \
      -Dvulkan-drivers=true          \
      ..                             &&

unset GALLIUM_DRIVERS DRI_DRIVERS EGL_PLATFORMS &&

ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-21.1.0 &&
cp -rfv ../docs/* /usr/share/doc/mesa-21.1.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

