#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Mesa is an OpenGL compatible 3Dbr3ak graphics library.br3ak"
SECTION="x"
VERSION=18.1.7
NAME="mesa"

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#Mako
#REQ:python2
#REQ:wayland
#REC:wayland-protocols
#REC:llvm
#REC:wayland
#REC:libva-wo-mesa
#REC:libvdpau
#OPT:libgcrypt
#OPT:nettle


cd $SOURCE_DIR

URL=https://mesa.freedesktop.org/archive/$NAME-$VERSION.tar.xz

echo "PATH : $PATH"

if [ ! -z $URL ]
then

wget -nc $URL

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
  --enable-vdpau \
  --enable-va
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
install -v -dm755 /usr/share/doc/$NAME-$VERSION &&
cp -rfv docs/* /usr/share/doc/$NAME-$VERSION

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
