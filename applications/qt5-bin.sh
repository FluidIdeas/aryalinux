#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qt5 is a cross-platformbr3ak application framework that is widely used for developingbr3ak application software with a graphical user interface (GUI) (inbr3ak which cases Qt5 is classified as abr3ak widget toolkit), and also used for developing non-GUI programs suchbr3ak as command-line tools and consoles for servers. One of the majorbr3ak users of Qt is KDE Frameworks 5 (KF5).br3ak"
SECTION="x"
VERSION=5.10.1
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

URL=http://aryalinux.com/files/binaries/qt-5.10.1-x86_64.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
sudo tar xf $TARBALL -C /
sudo mkdir -pv /opt/qt-5.10.1
sudo ln -sfnv qt-5.10.1 /opt/qt5

sudo tee /etc/ld.so.conf << EOF
# Begin Qt addition
/opt/qt5/lib
# End Qt addition
EOF
sudo ldconfig


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
