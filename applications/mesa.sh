#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Mesa is an OpenGL compatible 3Dbr3ak graphics library.br3ak"
SECTION="x"
VERSION=18.2.2
NAME="mesa"

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#Mako
#REQ:python2
#REQ:wayland
#REC:llvm
#REC:wayland-protocols
#REC:plasma-all
#REC:gtk3
#REC:libva-wo-mesa
#REC:libvdpau
#OPT:libgcrypt
#OPT:nettle


cd $SOURCE_DIR

URL=https://mesa.freedesktop.org/archive/mesa-18.2.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://mesa.freedesktop.org/archive/mesa-18.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-18.2.2.tar.xz || wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-18.2.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-18.2.2-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-18.2.2-add_xdemos-1.patch

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
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../mesa-18.2.2-add_xdemos-1.patch


GLL_DRV="i915,r600,nouveau,radeonsi,svga,swrast"


./configure CFLAGS='-O2' CXXFLAGS='-O2' LDFLAGS=-lLLVM \
            --prefix=/usr              \
            --sysconfdir=/etc                  \
            --enable-osmesa                    \
            --enable-xa                        \
            --enable-glx-tls                   \
            --with-platforms="drm,x11,wayland,wayland" \
            --with-gallium-drivers=$GLL_DRV    &&
unset GLL_DRV &&
make "-j`nproc`" || make


make -C xdemos DEMOS_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-18.2.2 &&
cp -rfv docs/* /usr/share/doc/mesa-18.2.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
