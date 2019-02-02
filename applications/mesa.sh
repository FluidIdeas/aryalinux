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

wget -nc https://mesa.freedesktop.org/archive/mesa-18.3.2.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-18.3.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.4/mesa-18.3.2-add_xdemos-1.patch

NAME=mesa
VERSION=18.3.2
URL=https://mesa.freedesktop.org/archive/mesa-18.3.2.tar.xz

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

patch -Np1 -i ../mesa-18.3.2-add_xdemos-1.patch
DRI_DRIVERS="i915,i965,nouveau,r200,radeon,swrast"
GALLIUM_DRIVERS="nouveau,r300,r600,svga,radeonsi,swrast,virgl"
VULKAN=" --with-vulkan-drivers=intel,radeon "
EGL_PLATFORMS="drm,x11"

export XORG_PREFIX=/usr

./configure CFLAGS='-O2' CXXFLAGS='-O2' LDFLAGS=-lLLVM \
  --prefix=$XORG_PREFIX \
  --sysconfdir=/etc \
  --with-dri-driverdir=/usr/lib${LIBDIRSUFFIX}/xorg/modules/dri \
  --with-dri-drivers="$DRI_DRIVERS" \
  --with-gallium-drivers="$GALLIUM_DRIVERS" \
  --with-egl-platforms="$EGL_PLATFORMS" \
  $VULKAN \
  --enable-llvm \
  --enable-llvm-shared-libs \
  --enable-egl \
  --enable-texture-float \
  --enable-shared-glapi \
  --enable-xa \
  --enable-nine \
  --enable-osmesa \
  --enable-dri \
  --enable-dri3 \
  --enable-gbm \
  --enable-glx \
  --enable-glx-tls \
  --enable-gles1 \
  --enable-gles2 \
  --enable-vdpau \
  --enable-va
make "-j`nproc`" || make
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX
sudo make install
sudo install -v -dm755 /usr/share/doc/mesa-18.3.2
sudo cp -rfv docs/* /usr/share/doc/mesa-18.3.2

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
