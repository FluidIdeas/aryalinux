#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#mako
#REQ:libva-wo-mesa
#REQ:libvdpau
#REQ:llvm
#REQ:wayland-protocols


cd $SOURCE_DIR

NAME=mesa
VERSION=22.1.2
URL=https://mesa.freedesktop.org/archive/mesa-22.1.2.tar.xz
SECTION="Graphical Environments"
DESCRIPTION="Mesa is an OpenGL compatible 3D graphics library."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://mesa.freedesktop.org/archive/mesa-22.1.2.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-22.1.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/5.0/mesa-22.1.2-add_xdemos-1.patch
wget -nc https://archive.mesa3d.org/demos/


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

patch -Np1 -i ../mesa-22.1.2-add_xdemos-1.patch

export XORG_PREFIX=/usr

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX          \
      --sysconfdir=/etc              \
      -Dllvm=true                    \
      -Dshared-llvm=true             \
      -Degl=true                     \
      -Dshared-glapi=enabled         \
      -Dgallium-xa=true              \
      -Dgallium-nine=true            \
      -Dgallium-vdpau=true           \
      -Dgallium-va=true              \
      -Ddri3=true                    \
      -Dglx=dri                      \
      -Dosmesa=true                  \
      -Dgbm=true                     \
      -Dglx-direct=true              \
      -Dgles1=enabled                \
      -Dgles2=enabled                \
      -Dvalgrind=false               \
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
install -v -dm755 /usr/share/doc/mesa-22.1.2 &&
cp -rfv ../docs/* /usr/share/doc/mesa-22.1.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd