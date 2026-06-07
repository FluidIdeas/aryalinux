#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libxcvt
#REQ:wayland-protocols
#REQ:x7app
#REQ:x7font
#REQ:libepoxy

cd $SOURCE_DIR
NAME=xwayland
VERSION=24.1.9
URL=https://www.x.org/pub/individual/xserver/xwayland-24.1.9.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.x.org/pub/individual/xserver/xwayland-24.1.9.tar.xz


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

sed -i '/install_man/,$d' meson.build
mkdir build
cd    build
meson setup ..              \
      --prefix=$XORG_PREFIX \
      --buildtype=release   \
      -D xkb_output_dir=/var/lib/xkb
ninja
mkdir tools
pushd tools
git clone https://gitlab.freedesktop.org/mesa/piglit.git --depth 1
cat > piglit/piglit.conf << EOF
[xts]
path=$(pwd)/xts
EOF

git clone https://gitlab.freedesktop.org/xorg/test/xts --depth 1
export DISPLAY=:22
../hw/vfb/Xvfb $DISPLAY &
VFB_PID=$!
cd xts
CFLAGS=-fcommon ./autogen.sh
make
kill $VFB_PID
unset DISPLAY VFB_PID
popd
XTEST_DIR=$(pwd)/tools/xts PIGLIT_DIR=$(pwd)/tools/piglit ninja test


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vm755 hw/vfb/Xvfb /usr/bin
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd