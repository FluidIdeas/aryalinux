#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=attica5
URL=https://download.kde.org/stable/frameworks/5.47/attica-5.47.0.tar.xz
VERSION=5.47.0

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5

pathappend $KF5_PREFIX/bin             PATH
pathappend $KF5_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend /etc/xdg                    XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/etc/xdg         XDG_CONFIG_DIRS
pathappend /usr/share                  XDG_DATA_DIRS
pathappend $KF5_PREFIX/share           XDG_DATA_DIRS
pathappend $KF5_PREFIX/lib/plugins     QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/qml         QML2_IMPORT_PATH
pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH
pathappend $QT5DIR/plugins             QT_PLUGIN_PATH
pathappend $QT5DIR/qml                 QML2_IMPORT_PATH


sudo install -v -dm755           $KF5_PREFIX/{etc,share} &&
sudo ln -sfv /etc/dbus-1         $KF5_PREFIX/etc         &&
sudo ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share
sudo install -v -dm755                $KF5_PREFIX/share/icons &&
sudo ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons

export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5

tar xf $TARBALL
pushd $DIRECTORY

mkdir build
cd    build
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_PREFIX_PATH=$QT5DIR        \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..
make "-j`nproc`"
sudo make install

popd

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

