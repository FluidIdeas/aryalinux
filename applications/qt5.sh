#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qt5 is a cross-platformbr3ak application framework that is widely used for developingbr3ak application software with a graphical user interface (GUI) (inbr3ak which cases Qt5 is classified as abr3ak widget toolkit), and also used for developing non-GUI programs suchbr3ak as command-line tools and consoles for servers. One of the majorbr3ak users of Qt is KDE Frameworks 5 (KF5).br3ak"
SECTION="x"
VERSION=5.11.0
NAME="qt5"

#REQ:x7lib
#REC:alsa-lib
#REC:make-ca
#REC:cups
#REC:glib2
#REC:gst10-plugins-base
#REC:harfbuzz
#REC:icu
#REC:jasper
#REC:libjpeg
#REC:libmng
#REC:libpng
#REC:libtiff
#REC:libxkbcommon
#REC:mesa
#REC:mtdev
#REC:pcre2
#REC:sqlite
#REC:wayland
#REC:xcb-util-image
#REC:xcb-util-keysyms
#REC:xcb-util-renderutil
#REC:xcb-util-wm
#OPT:bluez
#OPT:ibus
#OPT:x7driver
#OPT:mariadb
#OPT:pciutils
#OPT:postgresql
#OPT:pulseaudio
#OPT:unixodbc


cd $SOURCE_DIR

URL=https://download.qt.io/archive/qt/5.11/5.11.0/single/qt-everywhere-src-5.11.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.qt.io/archive/qt/5.11/5.11.0/single/qt-everywhere-src-5.11.0.tar.xz

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

export QT5PREFIX=/usr


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
            -examplesdir    /usr/share/doc/qt5/examples \
            -skip qtwebengine                          &&
make "-j`nproc`" || make
sudo make install
sudo find $QT5PREFIX/ -name \*.prl \
   -exec sudo sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

QT5BINDIR=$QT5PREFIX/bin

sudo install -v -dm755 /usr/share/pixmaps/                  &&
sudo install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png /usr/share/pixmaps/assistant-qt5.png &&
sudo install -v -Dm644 qttools/src/designer/src/designer/images/designer.png /usr/share/pixmaps/designer-qt5.png  &&
sudo install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png /usr/share/pixmaps/linguist-qt5.png  &&
sudo install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png /usr/share/pixmaps/qdbusviewer-qt5.png &&
sudo install -dm755 /usr/share/applications
sudo tee /usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=$QT5PREFIX/bin/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF
sudo tee /usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=$QT5PREFIX/bin/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
sudo tee /usr/share/applications/linguist-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=$QT5PREFIX/bin/linguist
Icon=linguist-qt5.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
sudo tee /usr/share/applications/qdbusviewer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT5PREFIX/bin/qdbusviewer
Icon=qdbusviewer-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF


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


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
