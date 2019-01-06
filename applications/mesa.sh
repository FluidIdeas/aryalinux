#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:x7lib
#REQ:libdrm
#REQ:Mako
#REC:libva
#REC:libvdpau
#REC:llvm
#REC:systems
#REC:wayland-protocols
#REC:plasma-all
#REC:gtk3
#OPT:libgcrypt
#OPT:nettle
#OPT:python2

cd $SOURCE_DIR

wget -nc https://mesa.freedesktop.org/archive/mesa-18.3.1.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-18.3.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-18.3.1-add_xdemos-1.patch

NAME=mesa
VERSION=18.3.1
URL=https://mesa.freedesktop.org/archive/mesa-18.3.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

patch -Np1 -i ../mesa-18.3.1-add_xdemos-1.patch
GLL_DRV="i915,nouveau,radeonsi,svga,swrast"
./configure CFLAGS='-O2' CXXFLAGS='-O2' LDFLAGS=-lLLVM \
            --prefix=$XORG_PREFIX              \
            --sysconfdir=/etc                  \
            --enable-osmesa                    \
            --enable-xa                        \
            --enable-glx-tls                   \
            --with-platforms="drm,x11,wayland" \
            --with-gallium-drivers=$GLL_DRV    &&

unset GLL_DRV &&

make
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -dm755 /usr/share/doc/mesa-18.3.1 &&
cp -rfv docs/* /usr/share/doc/mesa-18.3.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
