#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cmake
#REQ:gnutls
#REQ:pixman
#REQ:systemd
#REQ:x7app
#REQ:xinit
#REQ:imagemagick

cd $SOURCE_DIR
NAME=tigervnc
VERSION=1.16.0
URL=https://github.com/TigerVNC/tigervnc/archive/v1.16.0/tigervnc-1.16.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/TigerVNC/tigervnc/archive/v1.16.0/tigervnc-1.16.0.tar.gz


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

patch -Np1 -i ../tigervnc-1.16.0-configuration_fixes-1.patch
sed -i "/FL_MINOR_VERSION/s/3/4/" CMakeLists.txt
# Put code in place
mkdir -p unix/xserver
tar -xf ../xorg-server-21.1.21.tar.xz \
    --strip-components=1              \
    -C unix/xserver
( cd unix/xserver
patch -Np1 -i ../xserver21.patch )
# Build viewer
cmake -G "Unix Makefiles"          \
      -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -W no-dev .
make
# Build server
pushd unix/xserver
autoreconf -fiv
CPPFLAGS="-I/usr/include/drm"       \
  ./configure $XORG_CONFIG            \
      --disable-xwayland    --disable-dri        --disable-dmx         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --disable-static      --enable-dri3                              \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --with-pic
make
popd
cat > ~/.config/tigervnc/config << EOF
# Begin ~/.config/tigervnc/config
# The session must match one listed in /usr/share/xsessions.
# Ensure that there are no spaces at the end of the lines.

session=lxqt
geometry=1024x768

# End ~/.config/tigervnc/config
EOF
#Install viewer
make install
mv  /usr/share/doc/tigervnc /usr/share/doc/tigervnc-1.16.0

#Install server
( cd unix/xserver/hw/vnc
[ -e /usr/bin/Xvnc ] || ln -svf $XORG_PREFIX/bin/Xvnc /usr/bin/Xvnc
echo ":1=$(whoami)" >> /etc/tigervnc/vncserver.users
systemctl start vncserver@:1
systemctl enable vncserver@:1


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm 755 ~/.config/tigervnc
make install )
install -vdm755 /etc/X11/tigervnc
install -v -m755 ../Xsession /etc/X11/tigervnc
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd