#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Tigervnc is an advanced VNCbr3ak (Virtual Network Computing) implementation. It allows creation ofbr3ak an Xorg server not tied to a physical console and also provides abr3ak client for viewing of the remote graphical desktop.br3ak"
SECTION="xsoft"
VERSION=1.8.0
NAME="tigervnc"

#REQ:cmake
#REQ:fltk
#REQ:gnutls
#REQ:libgcrypt
#REQ:libjpeg
#REQ:pixman
#REQ:x7app
#REQ:x7legacy
#REC:imagemagick
#REC:linux-pam


cd $SOURCE_DIR

URL=https://github.com/TigerVNC/tigervnc/archive/v1.8.0/tigervnc-1.8.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/TigerVNC/tigervnc/archive/v1.8.0/tigervnc-1.8.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tigervnc/tigervnc-1.8.0.tar.gz
wget -nc https://www.x.org/pub/individual/xserver/xorg-server-1.19.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.19.3.tar.bz2

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

mkdir -vp build &&
cd        build &&
# Build viewer
cmake -G "Unix Makefiles"         \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -Wno-dev .. &&
make &&
# Build server
cp -vR ../unix/xserver unix/ &&
tar -xf ../../xorg-server-1.19.3.tar.bz2 -C unix/xserver --strip-components=1 &&
pushd unix/xserver &&
  patch -Np1 -i ../../../unix/xserver119.patch &&
  autoreconf -fi   &&
  ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static \
      --disable-xwayland    --disable-dri        --disable-dmx         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --disable-static      --enable-dri3                              \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --with-pic &&
  make TIGERVNC_SRCDIR=`pwd`/../../../ &&
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
#Install viewer
make install &&
#Install server
pushd unix/xserver/hw/vnc &&
  make install &&
popd &&
[ -e /usr/bin/Xvnc ] || ln -svf /usr/bin/Xvnc /usr/bin/Xvnc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/share/applications/vncviewer.desktop << "EOF"
[Desktop Entry]
Type=Application
Name=TigerVNC Viewer
Comment=VNC client
Exec=/usr/bin/vncviewer
Icon=tigervnc
Terminal=false
StartupNotify=false
Categories=Network;RemoteAccess;
EOF
install -vm644 ../media/icons/tigervnc_24.png /usr/share/pixmaps &&
ln -sfv tigervnc_24.png /usr/share/pixmaps/tigervnc.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
