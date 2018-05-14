#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:jack2
#REQ:qt5
#REQ:ffmpeg
#REQ:pulseaudio

cd $SOURCE_DIR

URL=https://github.com/MaartenBaert/ssr/archive/master.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"

CXXFLAGS="-fPIC" ./configure --prefix=/usr --with-qt5 --with-jack --with-pulseaudio &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
