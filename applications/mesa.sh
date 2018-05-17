#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Mesa is an OpenGL compatible 3Dbr3ak graphics library.br3ak"
SECTION="x"
VERSION=18.0.3
NAME="mesa"

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#Mako
#REQ:python2
#REQ:wayland
#REC:wayland-protocols
#REC:elfutils
#REC:llvm
#REC:wayland
#REC:libva-wo-mesa
#REC:libvdpau
#OPT:libgcrypt
#OPT:nettle


cd $SOURCE_DIR

URL=https://mesa.freedesktop.org/archive/mesa-18.0.3.tar.xz

if [ ! -z $URL ]
then

wget -nc $URL
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/mesa-18.0.3-add_xdemos-1.patch

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../mesa-18.0.3-add_xdemos-1.patch

DRI_DRIVERS="i915,i965,nouveau,r200,radeon,swrast"
GALLIUM_DRIVERS="nouveau,r300,r600,svga,radeonsi,swrast,virgl"
VULKAN=" --with-vulkan-drivers=intel,radeon "
EGL_PLATFORMS="drm,x11"


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
  --enable-vdpau
make "-j`nproc`" || make


make -C xdemos DEMOS_PREFIX=$XORG_PREFIX

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-18.0.3 &&
cp -rfv docs/* /usr/share/doc/mesa-18.0.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
