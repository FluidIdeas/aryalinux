#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libical
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:qrencode
#REQ:phonon
#REQ:plasma-wayland-protocols
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REQ:aspell
#REQ:avahi
#REQ:libdbusmenu-qt
#REQ:networkmanager
#REQ:polkit-qt
#REQ:kf5-intro
#REQ:noto-fonts
#REQ:oxygen-fonts
#REQ:bluez
#REQ:modemmanager
#REQ:jasper
#REQ:mitkrb
#REQ:udisks2
#REQ:upower
#REQ:media-player-info


NAME=kframeworks5
VERSION=5.82
SECTION="KDE Plasma 5"

cd $SOURCE_DIR

packages="
attica
kapidox
karchive
kcodecs
kconfig
kcoreaddons
kdbusaddons
kdnssd
kguiaddons
ki18n
kidletime
kimageformats
kitemmodels
kitemviews
kplotting
kwidgetsaddons
kwindowsystem
networkmanager-qt
solid
sonnet
threadweaver
kauth
kcompletion
kcrash
kdoctools
kpty
kunitconversion
kconfigwidgets
kservice
kglobalaccel
kpackage
kdesu
kemoticons
kiconthemes
kjobwidgets
knotifications
ktextwidgets
kxmlgui
kbookmarks
kwallet
kded
kio
kdeclarative
kcmutils
kirigami2
knewstuff
frameworkintegration
kinit
knotifyconfig
kparts
kactivities
syntax-highlighting
ktexteditor
kdesignerplugin
kwayland
plasma-framework
kpeople
kxmlrpcclient
bluez-qt
kfilemetadata
baloo
kactivities-stats
krunner
prison
qqc2-desktop-style
kjs
kdelibs4support
khtml
kjsembed
kmediaplayer
kross
kholidays
purpose
kcalendarcore
kcontacts
kquickcharts
kdav"

base_url="https://download.kde.org/stable/frameworks/$VERSION/"

for pkg in $(echo $packages); do
    if ! grep pkg /tmp/framework-pkgs &> /dev/null; then
        wget "$base_url$pkg-$VERSION.0.tar.xz"
        tarball=$(echo "$base_url$pkg-$VERSION.0.tar.xz" | rev | cut -d/ -f1 | rev)
        directory=$(tar tf $tarball | cut -d/ -f1 | uniq)

        tar xf $tarball
        pushd $directory
            mkdir build
            cd build
            cmake -DCMAKE_INSTALL_PREFIX=/usr      \
                -DCMAKE_BUILD_TYPE=Release         \
                -DBUILD_TESTING=OFF                \
                -Wno-dev ..
            make
            sudo make install
        popd
        sudo rm -rf $directory
        echo $pkg | tee -a /tmp/framework-pkgs
    fi
done

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
