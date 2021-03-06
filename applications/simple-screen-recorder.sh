#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=simple-screen-recorder
VERSION=0.3.11

#REQ:jack2
#REQ:qt5
#REQ:ffmpeg
#REQ:pulseaudio

cd $SOURCE_DIR

URL=https://github.com/MaartenBaert/ssr/archive/0.3.11.tar.gz
wget -nc $URL -O $NAME-$VERSION.tar.gz
TARBALL="$NAME-$VERSION.tar.gz"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DWITH_QT5=1 -DWITH_PULSEAUDIO=1 -DWITH_JACK=1 .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
