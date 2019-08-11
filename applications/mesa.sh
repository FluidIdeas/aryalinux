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

wget -nc https://mesa.freedesktop.org/archive/mesa-19.1.4.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-19.1.4.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/mesa-19.1.4-add_xdemos-1.patch
wget -nc ftp://ftp.freedesktop.org/pub/mesa/demos/


NAME=mesa
VERSION=19.1.4
URL=https://mesa.freedesktop.org/archive/mesa-19.1.4.tar.xz

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

patch -Np1 -i ../mesa-19.1.4-add_xdemos-1.patch
GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
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
      -Ddri-drivers=auto             \
      -Dgallium-drivers=auto         \
      -Dplatforms=auto               \
      -Dvulkan-drivers=auto          \
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
install -v -dm755 /usr/share/doc/mesa-19.1.4 &&
cp -rfv ../docs/* /usr/share/doc/mesa-19.1.4
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

