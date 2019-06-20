#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#mako
#REQ:libva
#REQ:libvdpau
#REQ:llvm
#REQ:wayland-protocols


cd $SOURCE_DIR

wget -nc https://mesa.freedesktop.org/archive/mesa-19.0.4.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-19.0.4.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-19.0.4-add_xdemos-2.patch
wget -nc ftp://ftp.freedesktop.org/pub/mesa/demos/


NAME=mesa
VERSION=19.0.4
URL=https://mesa.freedesktop.org/archive/mesa-19.0.4.tar.xz

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

patch -Np1 -i ../mesa-19.0.4-add_xdemos-2.patch
GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"
mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX          \
      -Dbuildtype=release            \
      -Ddri-drivers=$DRI_DRIVERS     \
      -Dgallium-drivers=$GALLIUM_DRV \
      -Dgallium-nine=true            \
      -Dglx=dri                      \
      -Dosmesa=gallium               \
      -Dvalgrind=false               \
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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-19.0.4 &&
cp -rfv ../docs/* /usr/share/doc/mesa-19.0.4
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

