#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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
#OPT:libinput
#OPT:mariadb
#OPT:pciutils
#OPT:postgresql
#OPT:pulseaudio
#OPT:unixodbc

cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.12/5.12.0/single/qt-everywhere-src-5.12.0.tar.xz

NAME=qt5
VERSION=5.12.0
URL=https://download.qt.io/archive/qt/5.12/5.12.0/single/qt-everywhere-src-5.12.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

export QT5PREFIX=/opt/qt5

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir /opt/qt-5.12.0
ln -sfnv qt-5.12.0 /opt/qt5
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

-archdatadir    /usr/lib/qt5                \
            -bindir         /usr/bin                    \
            -plugindir      /usr/lib/qt5/plugins        \
            -importdir      /usr/lib/qt5/imports        \
            -headerdir      /usr/include/qt5            \
            -datadir        /usr/share/qt5              \
            -docdir         /usr/share/doc/qt5          \
            -translationdir /usr/share/qt5/translations \
            -examplesdir    /usr/share/doc/qt5/examples
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
            -skip qtwebengine                           &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
find $QT5PREFIX/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
QT5BINDIR=$QT5PREFIX/bin

install -v -dm755 /usr/share/pixmaps/                  &&

install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png \
                  /usr/share/pixmaps/assistant-qt5.png &&

install -v -Dm644 qttools/src/designer/src/designer/images/designer.png \
                  /usr/share/pixmaps/designer-qt5.png  &&

install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
                  /usr/share/pixmaps/linguist-qt5.png  &&

install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  /usr/share/pixmaps/qdbusviewer-qt5.png &&

install -dm755 /usr/share/applications &&

cat > /usr/share/applications/assistant-qt5.desktop << EOF
<code class="literal">[Desktop Entry] Name=Qt5 Assistant Comment=Shows Qt5 documentation and examples Exec=$QT5BINDIR/assistant Icon=assistant-qt5.png Terminal=false Encoding=UTF-8 Type=Application Categories=Qt;Development;Documentation;</code>
EOF

cat > /usr/share/applications/designer-qt5.desktop << EOF
<code class="literal">[Desktop Entry] Name=Qt5 Designer GenericName=Interface Designer Comment=Design GUIs for Qt5 applications Exec=$QT5BINDIR/designer Icon=designer-qt5.png MimeType=application/x-designer; Terminal=false Encoding=UTF-8 Type=Application Categories=Qt;Development;</code>
EOF

cat > /usr/share/applications/linguist-qt5.desktop << EOF
<code class="literal">[Desktop Entry] Name=Qt5 Linguist Comment=Add translations to Qt5 applications Exec=$QT5BINDIR/linguist Icon=linguist-qt5.png MimeType=text/vnd.trolltech.linguist;application/x-linguist; Terminal=false Encoding=UTF-8 Type=Application Categories=Qt;Development;</code>
EOF

cat > /usr/share/applications/qdbusviewer-qt5.desktop << EOF
<code class="literal">[Desktop Entry] Name=Qt5 QDbusViewer GenericName=D-Bus Debugger Comment=Debug D-Bus applications Exec=$QT5BINDIR/qdbusviewer Icon=qdbusviewer-qt5.png Terminal=false Encoding=UTF-8 Type=Application Categories=Qt;Development;Debugger;</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT5BINDIR/$file /usr/bin/$file-qt5
done
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/profile.d/qt5.sh << "EOF"
<code class="literal"># Begin /etc/profile.d/qt5.sh QT5DIR=/usr export QT5DIR pathappend $QT5DIR/bin # End /etc/profile.d/qt5.sh</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/sudoers.d/qt << "EOF"
<code class="literal">Defaults env_keep += QT5DIR</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/ld.so.conf << EOF
<code class="literal"># Begin Qt addition /opt/qt5/lib # End Qt addition</code>
EOF

ldconfig
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/profile.d/qt5.sh << "EOF"
<code class="literal"># Begin /etc/profile.d/qt5.sh QT5DIR=/opt/qt5 pathappend $QT5DIR/bin PATH pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH export QT5DIR # End /etc/profile.d/qt5.sh</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
