#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:x7lib
#REQ:libdrm
#REQ:mako
#REQ:libva-wo-mesa
#REC:libvdpau
#REC:llvm
#REC:wayland-protocols

cd $SOURCE_DIR

wget -nc https://mesa.freedesktop.org/archive/mesa-19.0.2.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-19.0.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/mesa-19.0.2-add_xdemos-1.patch

NAME=mesa
VERSION=19.0.2
URL=https://mesa.freedesktop.org/archive/mesa-19.0.2.tar.xz

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

patch -Np1 -i ../mesa-19.0.2-add_xdemos-1.patch
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
      -Dgbm=true                     \
      -Dglx-direct=true              \
      -Dgles1=true                   \
      -Dgles2=true                   \
      -Dvalgrind=false               \
      -Dosmesa=gallium               \
      -Ddri-drivers=auto             \
      -Dgallium-drivers=auto         \
      -Dplatforms=auto               \
      -Dvulkan-drivers=auto          \
      ..                             &&

unset GALLIUM_DRIVERS DRI_DRIVERS EGL_PLATFORMS &&

ninja

make -C ../xdemos DEMOS_PREFIX=$XORG_PREFIX LIBRARY_PATH=$PWD/src/glx
sudo ninja install
sudo make -C ../xdemos DEMOS_PREFIX=$XORG_PREFIX install
sudo install -v -dm755 /usr/share/doc/mesa-19.0.2
sudo cp -rfv ../docs/* /usr/share/doc/mesa-19.0.2

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
