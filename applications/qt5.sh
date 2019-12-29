#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:alsa-lib
#REQ:make-ca
#REQ:cups
#REQ:glib2
#REQ:gst10-plugins-base
#REQ:harfbuzz
#REQ:icu
#REQ:jasper
#REQ:libjpeg
#REQ:libmng
#REQ:libpng
#REQ:libtiff
#REQ:libwebp
#REQ:libxkbcommon
#REQ:mesa
#REQ:mtdev
#REQ:pcre2
#REQ:sqlite
#REQ:wayland
#REQ:xcb-util-image
#REQ:xcb-util-keysyms
#REQ:xcb-util-renderutil


cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.13/5.13.0/single/qt-everywhere-src-5.13.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/qt-5.13.0-upstream_fixes-1.patch


NAME=qt5
VERSION=5.13.0
URL=https://download.qt.io/archive/qt/5.13/5.13.0/single/qt-everywhere-src-5.13.0.tar.xz

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

patch -Np1 -i ../qt-5.13.0-upstream_fixes-1.patch
export QT5PREFIX=/usr
sed -i 's/python /python3 /' qtdeclarative/qtdeclarative.pro \
                             qtdeclarative/src/3rdparty/masm/masm.pri &&

./configure -prefix $QT5PREFIX                          \
            -sysconfdir /etc/xdg                        \
            -confirm-license                            \
            -opensource                                 \
            -dbus-linked                                \
            -openssl-linked                             \
            -system-harfbuzz                            \
            -system-sqlite                              \
            -nomake examples                            \
            -no-rpath                                   \
            -archdatadir    /usr/lib/qt5                \
            -bindir         /usr/bin                    \
            -plugindir      /usr/lib/qt5/plugins        \
            -importdir      /usr/lib/qt5/imports        \
            -headerdir      /usr/include/qt5            \
            -datadir        /usr/share/qt5              \
            -docdir         /usr/share/doc/qt5          \
            -translationdir /usr/share/qt5/translations \
            -examplesdir    /usr/share/doc/qt5/examples &&
make -j$(nproc)
sudo make install
find $QT5PREFIX/ -name \*.prl \
   -exec sudo sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
export QT5BINDIR=$QT5PREFIX/bin
for file in moc uic rcc qmake lconvert lrelease lupdate; do
  sudo ln -sfrvn $QT5BINDIR/$file /usr/bin/$file-qt5
done

sudo tee /etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh

QT5DIR=/usr
export QT5DIR
pathappend $QT5DIR/bin

# End /etc/profile.d/qt5.sh
EOF

sudo tee /etc/sudoers.d/qt << "EOF"
Defaults env_keep += QT5DIR
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

