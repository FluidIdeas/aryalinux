#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="kde5-deps-stage2"
DESCRIPTION="KDE Frameworks 5 is a collection of libraries based on top of Qt5 and QML derived from the monolithic KDE 4 libraries."
VERSION=5.47

packages="kdnssd
kauth
kcompletion
kcrash
kglobalaccel
kjobwidgets
kunitconversion
kpty
kservice
kpeople
kfilemetadata
portingAids/kjsembed
kconfigwidgets
kdesu
kemoticons
kiconthemes
kapidox
knotifications
ktextwidgets
kpackage
kxmlgui
gpgmepp
kwallet
kbookmarks
prison
kio
kxmlrpcclient
kparts
kinit
kdeclarative
kcmutils
knewstuff
knotifyconfig
kactivities
frameworkintegration
kdesignerplugin
portingAids/khtml
ktexteditor
kdewebkit
portingAids/kross
plasma-framework
portingAids/krunner
portingAids/kmediaplayer
kded
portingAids/kdelibs4support
baloo5
kscreenlocker"

BASE_URL=http://download.kde.org/stable/frameworks/$VERSION

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

cd $SOURCE_DIR

mkdir -pv $NAME
pushd $NAME
touch build-log

for package in $packages; do
	if ! grep $package build-log &> /dev/null; then
		wget -nc $BASE_URL/$package-$VERSION.0.tar.xz
		TARBALL="$(echo $package-$VERSION.0.tar.xz | sed 's@portingAids/@@g')"
		DIRECTORY="$(echo $package-$VERSION.0 | sed 's@portingAids/@@g')"
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

		echo "$package=>`date`" >> build-log

		rm -rf $DIRECTORY
	else
		echo "$package installed. Skipping."
	fi
done

popd

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"